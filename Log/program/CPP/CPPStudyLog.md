# C++ Study log
---

## shared_from_this()

### 需要注意1.

enable_shared_from_this是一个模板类，定义于头文件<memory>，其原型为：

```c++
template< class T > class enable_shared_from_this;
```
> std::enable_shared_from_this 能让一个对象（假设其名为 t ，且已被一个 std::shared_ptr 对象 pt 管理）安全地生成其他额外的 std::shared_ptr 实例（假设名为 pt1, pt2, ... ） ，它们与 pt 共享对象 t 的所有权。
> 若一个类 T 继承 std::enable_shared_from_this<T> ，则会为该类 T 提供成员函数： shared_from_this 。 当 T 类型对象 t 被一个为名为 pt 的 std::shared_ptr<T> 类对象管理时，调用 T::shared_from_this 成员函数，将会返回一个新的 std::shared_ptr<T> 对象，它与 pt 共享 t 的所有权。

> 使用场合
>* 当类A被share_ptr管理，且在类A的成员函数里需要把当前类对象作为参数传给其他函数时，就需要传递一个指向自身的share_ptr。

* 1.为何不直接传递this指针

       使用智能指针的初衷就是为了方便资源管理，如果在某些地方使用智能指针，某些地方使用原始指针，很容易破坏智能指针的语义，从而产生各种错误。

* 2.可以直接传递share_ptr<this>么？

       答案是不能，因为这样会造成2个非共享的share_ptr指向同一个对象，未增加引用计数导对象被析构两次。例如：

```c++
#include <memory>
#include <iostream>
 
class Bad
{
public:
	std::shared_ptr<Bad> getptr() {
		return std::shared_ptr<Bad>(this);
	}
	~Bad() { std::cout << "Bad::~Bad() called" << std::endl; }
};
 
int main()
{
	// 错误的示例，每个shared_ptr都认为自己是对象仅有的所有者
	std::shared_ptr<Bad> bp1(new Bad());
	std::shared_ptr<Bad> bp2 = bp1->getptr();
	// 打印bp1和bp2的引用计数
	std::cout << "bp1.use_count() = " << bp1.use_count() << std::endl;
	std::cout << "bp2.use_count() = " << bp2.use_count() << std::endl;
}  // Bad 对象将会被删除两次
```
输出结果如下:
```c++
bp1.use_count() = 1
bp2.use_count() = 1
Bad::~Bad() called
Bad::~Bad() called
```
* **当然，一个对象被删除两次会导致崩溃**

正确的实现如下：
```c++
#include <memory>
#include <iostream>
 
struct Good : std::enable_shared_from_this<Good> // 注意：继承
{
public:
	std::shared_ptr<Good> getptr() {
		return shared_from_this();
	}
	~Good() { std::cout << "Good::~Good() called" << std::endl; }
};
 
int main()
{
	// 大括号用于限制作用域，这样智能指针就能在system("pause")之前析构
	{
		std::shared_ptr<Good> gp1(new Good());
		std::shared_ptr<Good> gp2 = gp1->getptr();
		// 打印gp1和gp2的引用计数
		std::cout << "gp1.use_count() = " << gp1.use_count() << std::endl;
		std::cout << "gp2.use_count() = " << gp2.use_count() << std::endl;
	}
	system("pause");
} 
```
输出结果如下:
```c++
gp1.use_count() = 2
gp1.use_count() = 2
Good::~Good() called
```
> 为何会出现这种使用场合
>* 因为在异步调用中，存在一个保活机制，异步函数执行的时间点我们是无法确定的，然而异步函数可能会使用到异步调用之前就存在的变量。为了保证该变量在异步函数执期间一直有效，我们可以传递一个指向自身的share_ptr给异步函数，这样在异步函数执行期间share_ptr所管理的对象就不会析构，所使用的变量也会一直有效了（保活）。

### 需要注意2.

> 在一个类中需要传递类对象本身shared_ptr的地方使用shared_from_this函数来获得指向自身的shared_ptr，它是enable_shared_from_this的成员函数，返回shared_ptr。
> 这个函数仅在shared_ptr的构造函数被调用之后才能使用。原因是enable_shared_from_this::weak_ptr并不在enable_shared_from_this构造函数中设置，而是在**shared_ptr**的构造函数中设置 

>* 1.首先需要注意的是：这个函数仅在shared_ptr<T>的构造函数被调用之后才能使用。原因是enable_shared_from_this::weak_ptr并不在enable_shared_from_this<T>构造函数中设置，而是在shared_ptr<T>的构造函数中设置.

* a) 如下代码是错误的：
```c++
class D:public boost::enable_shared_from_this<D>
{
public:
    D()
    {
        boost::shared_ptr<D> p=shared_from_this();
    }
};
```

> 原因很简单，在D的构造函数中虽然可以保证enable_shared_from_this<D>的构造函数已经被调用，但正如前面所说，weak_ptr还没有设置。 

* b) 如下代码也是错误的：
```c++
class D:public boost::enable_shared_from_this<D>
{
public:
    void func()
    {
        boost::shared_ptr<D> p=shared_from_this();
    }
};
void main()
{
    D d;
    d.func();
}
```
错误原因同上。 
* c) 如下代码是正确的：
```c++
void main()
{
    boost::shared_ptr<D> d(new D);
    d->func();
}
```
> 这里boost::shared_ptr<D> d(new D)实际上执行了3个动作：
>* 1. 首先调用enable_shared_from_this<D>的构造函数；
>* 2. 其次调用D的构造函数；
>* 3. 最后调用shared_ptr<D>的构造函数。
是第3个动作设置了enable_shared_from_this<D>的weak_ptr，而不是第1个动作。这个地方是很违背c++常理和逻辑的，必须小心。 

* 结论是：不要在构造函数中使用shared_from_this；其次，如果要使用shared_ptr，则应该在所有地方均使用，不能使用D d这种方式，也决不要传递裸指针。 

