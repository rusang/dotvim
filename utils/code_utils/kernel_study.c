/**
 * kernel tricks
 */

//编译期间就发现这些潜在的致命错误
/* Force a compilation error if condition is true */
#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))

/* Force a compilation error if condition is true, but also produce a
   result (of value 0 and type size_t), so the expression can be used
   e.g. in a structure initializer (or where-ever else comma expressions
   aren't permitted). */
#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)

//extend:
#define BUILD_BUG_ON_ZERO(e)  (sizeof(struct{int : -!!(e);}))
#define BUILD_BUG_ON_NULL(e)  ((void*)sizeof(struct{int : -!!(e);}))

#define BUILD_BUG_ON(condition)  ((void)BUILD_BUG_ON_ZERO(condition))

#define MAYBE_BUILD_BUG_ON(condition)  ((void)sizeof(char[1 - 2 * !!(condition)]))

//-----------------------------------------------------------------------------
//
//编译期间就发现这些潜在的type error, especially in macro definations
/*
 * Check at compile time that something is of a particular type.
 * Always evaluates to 1 so you may use it easily in comparisons.
 */
#define typecheck(type,x) \
({	type __dummy; \
	typeof(x) __dummy2; \
	(void)(&__dummy == &__dummy2); \
	1; \
})

/*
 * Check at compile time that 'function' is a certain type, or is a pointer
 * to that type (needs to use typedef for the function type.)
 */
#define typecheck_fn(type,function) \
({	typeof(type) __tmp = function; \
	(void)__tmp; \
})

//-----------------------------------------------------------------------------
