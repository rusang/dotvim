//¶¨Òådebug ¿ª¹Ø
#define __DEBUG__
#define __ERROR__


#define USHORT_MAX  ((u16)(~0U))
#define SHORT_MAX   ((s16)(USHORT_MAX>>1))
#define SHORT_MIN   (-SHORT_MAX - 1)
#define INT_MAX     ((int)(~0U>>1))
#define INT_MIN     (-INT_MAX - 1)
#define UINT_MAX    (~0U)
#define LONG_MAX    ((long)(~0UL>>1))
#define LONG_MIN    (-LONG_MAX - 1)
#define ULONG_MAX   (~0UL)
#define LLONG_MAX   ((long long)(~0ULL>>1))
#define LLONG_MIN   (-LLONG_MAX - 1)
#define ULLONG_MAX  (~0ULL)


#ifdef __DEBUG__
#define DEBUG(fmt, args...) printf("[%s:%d] " fmt "\n",   \
                                   __FUNCTION__, __LINE__ , ## args)
#else
#define DEBUG(fmt, args...)  do {} while(0)
#endif


#ifdef __ERROR__
#define ERROR(fmt, args...) \
	do{\
		printf("###########ERROR INFO:\n");\
		printf("[%s:%s:%d] " fmt "\n",   \
		       __FILE__, __FUNCTION__, __LINE__ , ## args);\
	}while(0)
#else
#define ERROR(fmt, args...)  do {} while(0)
#endif

/*
 * ½ø³öº¯ÊýÐÅÏ¢
 */
#ifdef __DEBUG__
#define enter(x)   printf("Enter: %s, %s line %i\n",x,__FILE__,__LINE__)
#define leave(x)   printf("Leave: %s, %s line %i\n",x,__FILE__,__LINE__)

#define ENTER()     enter(__FUNCTION__)
#define LEAVE()     leave(__FUNCTION__)
#else
#define enter(x)   do {} while (0)
#define leave(x)   do {} while (0)

#define ENTER()     do {} while (0)
#define LEAVE()     do {} while (0)
#endif

#define STATIC      static

#define INLINE      inline

#ifndef LIKELY
#define LIKELY(x)    (x)
#endif
#ifndef UNLIKELY
#define UNLIKELY(x) (x)
#endif

#ifndef __used
#define __used          /* unimplemented */
#endif

#ifndef __maybe_unused
#define __maybe_unused      /* unimplemented */
#endif

#ifndef noinline
#define noinline
#endif


#ifndef MIN
#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a, b) (((a) > (b)) ? (a) : (b))
#endif

#ifndef offset_of
#define offset_of(type, memb) \
	((unsigned long)(&((type *)0)->memb))
#endif
#ifndef container_of
#define container_of(obj, type, memb) \
	((type *)(((char *)obj) - offset_of(type, memb)))
#endif

/*
 * swap - swap value of @a and @b
 */
#define swap(a, b) \
	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)

#define container_of(ptr, type, member) ({          \
		const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
		(type *)( (char *)__mptr - offsetof(type,member) );})

#define __ALIGN_MASK(x,mask)    (((x)+(mask))&~(mask))
#define ALIGN(x,a)      __ALIGN_MASK(x,(typeof(x))(a)-1)

#define IS_ALIGNED(x, a)        (((x) & ((typeof(x))(a) - 1)) == 0)

#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))

#ifdef __GNUC__
#define TYPEOF(x) (__typeof__(x))
#else
#define TYPEOF(x)
#endif

#define PTR_ALIGN(p, a)     ((typeof(p))ALIGN((unsigned long)(p), (a)))


#define ABS(x) ({               \
		long __x = (x);         \
		(__x < 0) ? -__x : __x;     \
	})

#define lower_32_bits(n) ((u32)(n))

#define KERN_EMERG   "<0>"   /* system is unusable           */
#define KERN_ALERT   "<1>"   /* action must be taken immediately */
#define KERN_CRIT    "<2>"   /* critical conditions          */
#define KERN_ERR     "<3>"   /* error conditions         */
#define KERN_WARNING "<4>"   /* warning conditions           */
#define KERN_NOTICE  "<5>"   /* normal but significant condition */
#define KERN_INFO    "<6>"   /* informational            */
#define KERN_DEBUG   "<7>"   /* debug-level messages         */

/*
 * dump data
 */
#ifdef __DEBUG__
#define DUMPDATA(addr,len) \
	do  \
	{ \
		int i = 1; \
		char *src_ = addr; \
		for (i = 1; i <= len; i++) \
		{       \
			printf("0x%x	", *src_++); \
			if(0 == i%16)       \
				printf("\n");   \
		}                   \
	} while (0)
#else
#define DUMPDATA(addr, len)  do {} while(0)
#endif


/*
 * rbtree
 */
struct rb_node {
	unsigned long  rb_parent_color;
#define RB_RED      0
#define RB_BLACK    1
	struct rb_node *rb_right;
	struct rb_node *rb_left;
} __attribute__((aligned(sizeof(long))));
/* The alignment might seem pointless, but allegedly CRIS needs it */

struct rb_root {
	struct rb_node *rb_node;
};

/*
 *  These inlines deal with timer wrapping correctly. You are
 *  strongly encouraged to use them
 *  1. Because people otherwise forget
 *  2. Because if the timer wrap changes in future you won't have to
 *     alter your driver code.
 *
 * time_after(a,b) returns true if the time a is after time b.
 *
 * Do this with "<0" and ">=0" to only test the sign of the result. A
 * good compiler would generate better code (and a really good compiler
 * wouldn't care). Gcc is currently neither.
 */

/*
 * ·ÀÖ¹Òç³öµÄ±È½ÏÊ±¼ä´óÐ¡µÄ·½·¨
 */

#define typecheck
#define time_after(a,b)     \
	(typecheck(unsigned long, a) && \
	 typecheck(unsigned long, b) && \
	 ((long)(b) - (long)(a) < 0))
#define time_before(a,b)    time_after(b,a)

#define time_after_eq(a,b)  \
	(typecheck(unsigned long, a) && \
	 typecheck(unsigned long, b) && \
	 ((long)(a) - (long)(b) >= 0))
#define time_before_eq(a,b) time_after_eq(b,a)

/* give file/line information */
#define BUG()       __bug(__FILE__, __LINE__)

#define ASSERT(expr) ((void) ((expr) ? 0 : (err("assert failed at line %d",__LINE__))))

#ifdef __DEBUG__
#define ASSERT(expr) \
	if(!(expr)) { \
		printf( "Assertion failed! %s,%s,%s,line=%d\n",\
		        #expr,__FILE__,__func__,__LINE__); \
		BUG(); \
	}
#else
#define ASSERT(expr)
#endif


/*
 * alignment for basic types
 */
union align {
	int i;
	long l;
	long *lp;
	void *p;
	void (*fp)(void);
	float f;
	double d;
	long double ld;
	long long ll;
};

/* round nbytes to an alignment boundary */
nbytes = (((nbytes + sizeof(union align) - 1) / (sizeof(union align))) * (sizeof(union align)))

         /* Define ALIASNAME as a weak alias for NAME.
            If weak aliases are not available, this defines a strong alias.  */
# define weak_alias(name, aliasname) _weak_alias (name, aliasname)
         # define _weak_alias(name, aliasname) \
         extern __typeof (name) aliasname __attribute__ ((weak, alias (#name)));

         /* Change the owner and group of FILE; if it's a link, do the link and
          * not the target.
          */
         int
         __lchown(const char *file, uid_t owner, gid_t group)
{
	error_t err;
	file_t port = __file_name_lookup(file, O_NOLINK, 0);

	if (port == MACH_PORT_NULL)
		return -1;

	err = __file_chown(port, owner, group);
	__mach_port_deallocate(__mach_task_self(), port);

	if (err)
		return __hurd_fail(err);

	return 0;
}

weak_alias(__lchown, lchown)

/*
 * signal defination
 *
 */
/* Signals.  */
#define	SIGHUP		1	/* Hangup (POSIX).  */
#define	SIGINT		2	/* Interrupt (ANSI).  */
#define	SIGQUIT		3	/* Quit (POSIX).  */
#define	SIGILL		4	/* Illegal instruction (ANSI).  */
#define	SIGABRT		SIGIOT	/* Abort (ANSI).  */
#define	SIGTRAP		5	/* Trace trap (POSIX).  */
#define	SIGIOT		6	/* IOT trap (4.2 BSD).  */
#define	SIGEMT		7	/* EMT trap (4.2 BSD).  */
#define	SIGFPE		8	/* Floating-point exception (ANSI).  */
#define	SIGKILL		9	/* Kill, unblockable (POSIX).  */
#define	SIGBUS		10	/* Bus error (4.2 BSD).  */
#define	SIGSEGV		11	/* Segmentation violation (ANSI).  */
#define	SIGSYS		12	/* Bad argument to system call (4.2 BSD).  */
#define	SIGPIPE		13	/* Broken pipe (POSIX).  */
#define	SIGALRM		14	/* Alarm clock (POSIX).  */
#define	SIGTERM		15	/* Termination (ANSI).  */
#define	SIGURG		16	/* Urgent condition on socket (4.2 BSD).  */
#define	SIGSTOP		17	/* Stop, unblockable (POSIX).  */
#define	SIGTSTP		18	/* Keyboard stop (POSIX).  */
#define	SIGCONT		19	/* Continue (POSIX).  */
#define	SIGCHLD		20	/* Child status has changed (POSIX).  */
#define	SIGCLD		SIGCHLD	/* Same as SIGCHLD (System V).  */
#define	SIGTTIN		21	/* Background read from tty (POSIX).  */
#define	SIGTTOU		22	/* Background write to tty (POSIX).  */
#define	SIGIO		23	/* I/O now possible (4.2 BSD).  */
#define	SIGPOLL		SIGIO	/* Same as SIGIO? (SVID).  */
#define	SIGXCPU		24	/* CPU limit exceeded (4.2 BSD).  */
#define	SIGXFSZ		25	/* File size limit exceeded (4.2 BSD).  */
#define	SIGVTALRM	26	/* Virtual alarm clock (4.2 BSD).  */
#define	SIGPROF		27	/* Profiling alarm clock (4.2 BSD).  */
#define	SIGWINCH	28	/* Window size change (4.3 BSD, Sun).  */
#define SIGINFO		29	/* Information request (4.4 BSD).  */
#define	SIGUSR1		30	/* User-defined signal 1 (POSIX).  */
#define	SIGUSR2		31	/* User-defined signal 2 (POSIX).  */
#define SIGLOST		32	/* Resource lost (Sun); server died (GNU).  */

/*****************************************************************************\
 *                                                                            *
 * glibc 2.11 version                                                         *
 *                                                                            *
 *  from glibc                                                                *
 *                                                                            *
\*****************************************************************************/
/* Return a mask that includes the bit for SIG only.  */
# define __sigmask(sig) \
  (((unsigned long int) 1) << (((sig) - 1) % (8 * sizeof (unsigned long int))))

# define __sigmask(sig) (((__sigset_t) 1) << ((sig) - 1))

# define __SIGSETFN(NAME, BODY, CONST)                        \
		_EXTERN_INLINE int                                  \
	NAME (CONST __sigset_t *__set, int __sig)                   \
{                                       \
	__sigset_t __mask = __sigmask (__sig);                    \
	return BODY;                                  \
}

__SIGSETFN(__sigismember, (*__set &__mask) ? 1 : 0, const)
__SIGSETFN(__sigaddset, ((*__set |= __mask), 0),)
__SIGSETFN(__sigdelset, ((*__set &= ~__mask), 0),)

/*****************************************************************************\
 *                                                                            *
 * glibc 2.26 version                                                         *
 *  this version is better                                                    *
 *                                                                            *
 *  from glibc                                                                *
 *                                                                            *
\*****************************************************************************/
/* These macros needn't check for a bogus signal number;
   checking is done in the non-__ versions.  */
# define __sigismember(set, sig)		\
  (__extension__ ({				\
    __sigset_t __mask = __sigmask (sig);	\
    (set) & __mask ? 1 : 0;			\
  }))

# define __sigaddset(set, sig)			\
  (__extension__ ({				\
    __sigset_t __mask = __sigmask (sig);	\
    (set) |= __mask;				\
    (void)0;					\
  }))

# define __sigdelset(set, sig)			\
  (__extension__ ({				\
    __sigset_t __mask = __sigmask (sig);	\
    (set) &= ~__mask;				\
    (void)0;					\
  }))

/*****************************************************************************\
 *                                                                            *
 * use macro(int type) replace enum: means you can use enum to caculate       *
 *                                                                            *
 *  from stack overflow                                                       *
 *                                                                            *
\*****************************************************************************/
enum rtnetlink_groups {
	RTNLGRP_NONE
#define RTNLGRP_NONE            0
	= RTNLGRP_NONE,
	RTNLGRP_LINK
#define RTNLGRP_LINK            1
	= RTNLGRP_LINK,
	RTNLGRP_NOTIFY
#define RTNLGRP_NOTIFY          2
	= RTNLGRP_NOTIFY,
	RTNLGRP_NEIGH
#define RTNLGRP_NEIGH           3
	= RTNLGRP_NEIGH,
	RTNLGRP_TC
#define RTNLGRP_TC              4
	= RTNLGRP_TC,
	RTNLGRP_IPV4_IFADDR
#define RTNLGRP_IPV4_IFADDR     5
	= RTNLGRP_IPV4_IFADDR,
	/* ... */
};



/* RTnetlink multicast groups */
enum rtnetlink_groups {
	RTNLGRP_NONE,
#define RTNLGRP_NONE        RTNLGRP_NONE
	RTNLGRP_LINK,
#define RTNLGRP_LINK        RTNLGRP_LINK
	RTNLGRP_NOTIFY,
#define RTNLGRP_NOTIFY      RTNLGRP_NOTIFY
	RTNLGRP_NEIGH,
#define RTNLGRP_NEIGH       RTNLGRP_NEIGH
	RTNLGRP_TC,
#define RTNLGRP_TC      RTNLGRP_TC
	RTNLGRP_IPV4_IFADDR,
#define RTNLGRP_IPV4_IFADDR RTNLGRP_IPV4_IFADDR
	RTNLGRP_IPV4_MROUTE,
#define RTNLGRP_IPV4_MROUTE RTNLGRP_IPV4_MROUTE
	RTNLGRP_IPV4_ROUTE,
#define RTNLGRP_IPV4_ROUTE  RTNLGRP_IPV4_ROUTE
	RTNLGRP_IPV4_RULE,
#define RTNLGRP_IPV4_RULE   RTNLGRP_IPV4_RULE
	RTNLGRP_IPV6_IFADDR,
#define RTNLGRP_IPV6_IFADDR RTNLGRP_IPV6_IFADDR
	RTNLGRP_IPV6_MROUTE,
#define RTNLGRP_IPV6_MROUTE RTNLGRP_IPV6_MROUTE
	RTNLGRP_IPV6_ROUTE,
#define RTNLGRP_IPV6_ROUTE  RTNLGRP_IPV6_ROUTE
	RTNLGRP_IPV6_IFINFO,
#define RTNLGRP_IPV6_IFINFO RTNLGRP_IPV6_IFINFO
	RTNLGRP_DECnet_IFADDR,
#define RTNLGRP_DECnet_IFADDR   RTNLGRP_DECnet_IFADDR
	RTNLGRP_NOP2,
	RTNLGRP_DECnet_ROUTE,
#define RTNLGRP_DECnet_ROUTE    RTNLGRP_DECnet_ROUTE
	RTNLGRP_DECnet_RULE,
#define RTNLGRP_DECnet_RULE RTNLGRP_DECnet_RULE
	RTNLGRP_NOP4,
	RTNLGRP_IPV6_PREFIX,
#define RTNLGRP_IPV6_PREFIX RTNLGRP_IPV6_PREFIX
	RTNLGRP_IPV6_RULE,
#define RTNLGRP_IPV6_RULE   RTNLGRP_IPV6_RULE
	RTNLGRP_ND_USEROPT,
#define RTNLGRP_ND_USEROPT  RTNLGRP_ND_USEROPT
	RTNLGRP_PHONET_IFADDR,
#define RTNLGRP_PHONET_IFADDR   RTNLGRP_PHONET_IFADDR
	RTNLGRP_PHONET_ROUTE,
#define RTNLGRP_PHONET_ROUTE    RTNLGRP_PHONET_ROUTE
	RTNLGRP_DCB,
#define RTNLGRP_DCB     RTNLGRP_DCB
	RTNLGRP_IPV4_NETCONF,
#define RTNLGRP_IPV4_NETCONF    RTNLGRP_IPV4_NETCONF
	RTNLGRP_IPV6_NETCONF,
#define RTNLGRP_IPV6_NETCONF    RTNLGRP_IPV6_NETCONF
	RTNLGRP_MDB,
#define RTNLGRP_MDB     RTNLGRP_MDB
	RTNLGRP_MPLS_ROUTE,
#define RTNLGRP_MPLS_ROUTE  RTNLGRP_MPLS_ROUTE
	RTNLGRP_NSID,
#define RTNLGRP_NSID        RTNLGRP_NSID
	__RTNLGRP_MAX
};


/*****************************************************************************\
 *                                                                            *
 * siglist template                                                           *
 *                                                                            *
 *  from glibc                                                                *
 *                                                                            *
\*****************************************************************************/


/* start <siglist.h> file */

/* Standard signals  */
init_sig(SIGHUP, "HUP", N_("Hangup"))
init_sig(SIGINT, "INT", N_("Interrupt"))
init_sig(SIGQUIT, "QUIT", N_("Quit"))
init_sig(SIGILL, "ILL", N_("Illegal instruction"))
init_sig(SIGTRAP, "TRAP", N_("Trace/breakpoint trap"))
init_sig(SIGABRT, "ABRT", N_("Aborted"))
init_sig(SIGFPE, "FPE", N_("Floating point exception"))
init_sig(SIGKILL, "KILL", N_("Killed"))
init_sig(SIGBUS, "BUS", N_("Bus error"))
init_sig(SIGSEGV, "SEGV", N_("Segmentation fault"))
init_sig(SIGPIPE, "PIPE", N_("Broken pipe"))
init_sig(SIGALRM, "ALRM", N_("Alarm clock"))
init_sig(SIGTERM, "TERM", N_("Terminated"))
init_sig(SIGURG, "URG", N_("Urgent I/O condition"))
init_sig(SIGSTOP, "STOP", N_("Stopped (signal)"))
init_sig(SIGTSTP, "TSTP", N_("Stopped"))
init_sig(SIGCONT, "CONT", N_("Continued"))
init_sig(SIGCHLD, "CHLD", N_("Child exited"))
init_sig(SIGTTIN, "TTIN", N_("Stopped (tty input)"))
init_sig(SIGTTOU, "TTOU", N_("Stopped (tty output)"))
init_sig(SIGIO, "IO", N_("I/O possible"))
init_sig(SIGXCPU, "XCPU", N_("CPU time limit exceeded"))
init_sig(SIGXFSZ, "XFSZ", N_("File size limit exceeded"))
init_sig(SIGVTALRM, "VTALRM", N_("Virtual timer expired"))
init_sig(SIGPROF, "PROF", N_("Profiling timer expired"))
init_sig(SIGUSR1, "USR1", N_("User defined signal 1"))
init_sig(SIGUSR2, "USR2", N_("User defined signal 2"))

/* Variations  */
#ifdef SIGEMT
init_sig(SIGEMT, "EMT", N_("EMT trap"))
#endif
#ifdef SIGSYS
init_sig(SIGSYS, "SYS", N_("Bad system call"))
#endif
#ifdef SIGSTKFLT
init_sig(SIGSTKFLT, "STKFLT", N_("Stack fault"))
#endif
#ifdef SIGINFO
init_sig(SIGINFO, "INFO", N_("Information request"))
#elif defined(SIGPWR) && (!defined(SIGLOST) || (SIGPWR != SIGLOST))
init_sig(SIGPWR, "PWR", N_("Power failure"))
#endif
#ifdef SIGLOST
init_sig(SIGLOST, "LOST", N_("Resource lost"))
#endif
#ifdef SIGWINCH
init_sig(SIGWINCH, "WINCH", N_("Window changed"))
#endif
/* end  <siglist.h> file */

/* start  <siglist.c> file */
/* We define here all the signal names listed in POSIX (1003.1-2008);
   as of 1003.1-2013, no additional signals have been added by POSIX.
   We also define here signal names that historically exist in every
   real-world POSIX variant (e.g. SIGWINCH).

   Signals in the 1-15 range are defined with their historical numbers.
   For other signals, we use the BSD numbers.
   There are two unallocated signal numbers in the 1-31 range: 7 and 29.
   Signal number 0 is reserved for use as kill(pid, 0), to test whether
   a process exists without sending it a signal.  */

/* ISO C99 signals.  */
#define	SIGINT		2	/* Interactive attention signal.  */
#define	SIGILL		4	/* Illegal instruction.  */
#define	SIGABRT		6	/* Abnormal termination.  */
#define	SIGFPE		8	/* Erroneous arithmetic operation.  */
#define	SIGSEGV		11	/* Invalid access to storage.  */
#define	SIGTERM		15	/* Termination request.  */

/* Historical signals specified by POSIX. */
#define	SIGHUP		1	/* Hangup.  */
#define	SIGQUIT		3	/* Quit.  */
#define	SIGTRAP		5	/* Trace/breakpoint trap.  */
#define	SIGKILL		9	/* Killed.  */
#define SIGBUS		10	/* Bus error.  */
#define	SIGSYS		12	/* Bad system call.  */
#define	SIGPIPE		13	/* Broken pipe.  */
#define	SIGALRM		14	/* Alarm clock.  */

/* New(er) POSIX signals (1003.1-2008, 1003.1-2013).  */
#define	SIGURG		16	/* Urgent data is available at a socket.  */
#define	SIGSTOP		17	/* Stop, unblockable.  */
#define	SIGTSTP		18	/* Keyboard stop.  */
#define	SIGCONT		19	/* Continue.  */
#define	SIGCHLD		20	/* Child terminated or stopped.  */
#define	SIGTTIN		21	/* Background read from control terminal.  */
#define	SIGTTOU		22	/* Background write to control terminal.  */
#define	SIGPOLL		23	/* Pollable event occurred (System V).  */
#define	SIGXCPU		24	/* CPU time limit exceeded.  */
#define	SIGXFSZ		25	/* File size limit exceeded.  */
#define	SIGVTALRM	26	/* Virtual timer expired.  */
#define	SIGPROF		27	/* Profiling timer expired.  */
#define	SIGUSR1		30	/* User-defined signal 1.  */
#define	SIGUSR2		31	/* User-defined signal 2.  */

/* Nonstandard signals found in all modern POSIX systems
   (including both BSD and Linux).  */
#define	SIGWINCH	28	/* Window size change (4.3 BSD, Sun).  */

/* Archaic names for compatibility.  */
#define	SIGIO		SIGPOLL	/* I/O now possible (4.2 BSD).  */
#define	SIGIOT		SIGABRT	/* IOT instruction, abort() on a PDP-11.  */
#define	SIGCLD		SIGCHLD	/* Old System V name */

/* Not all systems support real-time signals.  bits/signum.h indicates
   that they are supported by overriding __SIGRTMAX to a value greater
   than __SIGRTMIN.  These constants give the kernel-level hard limits,
   but some real-time signals may be used internally by glibc.  Do not
   use these constants in application code; use SIGRTMIN and SIGRTMAX
   (defined in signal.h) instead.  */
#define __SIGRTMIN	32
#define __SIGRTMAX	__SIGRTMIN

/* Biggest signal number + 1 (including real-time signals).  */
#define _NSIG		(__SIGRTMAX + 1)
/* end  <siglist.c> file */

/**
 * examples
 */
const char *const __new_sys_siglist[NSIG] = {
#define init_sig(sig, abbrev, desc)   [sig] = desc,
#include <siglist.h>
#undef init_sig
};
libc_hidden_ver(__new_sys_siglist, _sys_siglist)

const char *const __new_sys_sigabbrev[NSIG] = {
#define init_sig(sig, abbrev, desc)   [sig] = abbrev,
#include <siglist.h>
#undef init_sig
};


/*****************************************************************************\
 *                                                                            *
 * no idea                                                                    *
 *                                                                            *
 *  from glibc and kernel                                                     *
 *                                                                            *
\*****************************************************************************/
/* Return values from callback functions.  */
enum {
	FTW_CONTINUE = 0, /* Continue with next sibling or for FTW_D with the
               first child.  */
# define FTW_CONTINUE   FTW_CONTINUE
	FTW_STOP = 1,     /* Return from `ftw' or `nftw' with FTW_STOP as return
               value.  */
# define FTW_STOP   FTW_STOP
	FTW_SKIP_SUBTREE = 2, /* Only meaningful for FTW_D: Don't walk through the
               subtree, instead just continue with its next
               sibling. */
# define FTW_SKIP_SUBTREE FTW_SKIP_SUBTREE
	FTW_SKIP_SIBLINGS = 3,/* Continue with FTW_DP callback for current directory
                (if FTW_DEPTH) and then its siblings.  */
# define FTW_SKIP_SIBLINGS FTW_SKIP_SIBLINGS
};


/*****************************************************************************\
 *                                                                            *
 * check is a value is defined in enum type                                   *
 *                                                                            *
 *  from stack overflow                                                       *
 *                                                                            *
\*****************************************************************************/
/* Only need to define values here, maybe more members needed here */
#define enum_vals(_) \
	_(A, 0x2E, ...)  \
	_(B, 0x23, ...)  \
	_(C, 0x40, ...)

#define def_enum(a, b, ...) a = b,
#define def_enum_arr(a, b, ...) b,

/* create enum and array */
#define CREATE_ENUM(enum_values, name) \
	typedef enum  _##name { \
		enum_values(def_enum) \
	} name; \
	const int array_##name[] = { \
		enum_values(def_enum_arr) \
	}

/* check is the vaule in the enum? */
#define enum_check(x, enum_type) \
	({ \
		int _i, _res = 0; \
		for (_i = 0; _i < sizeof(array_##enum_type); _i++) { \
			if (array_##enum_type[_i] == x) { \
				_res = 1; \
				break; \
			} \
		} \
		_res; \
	})

/* convert a enum to a int, is that necessary??? */
#define enum2int(x, enum_type) \
	({ \
		int _i, _res = -1; \
		if (!enum_check(x, enum_type)) { \
			ERROR("%s is not a %s member!",#x, #enum_type);\
		} else { \
			for (_i = 0; _i < sizeof(array_##enum_type); _i++) { \
				if (array_##enum_type[_i] == x) { \
					_res = array_##enum_type[_i]; \
					break; \
				} \
			} \
		} \
		_res; \
	})

CREATE_ENUM(enum_vals, enum_test);

/*****************************************************************************\
 *                                                                            *
 * typecheck and typecheck_fn                                                 *
 *                                                                            *
 *  from kernel                                                               *
 *                                                                            *
\*****************************************************************************/
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

/*****************************************************************************\
 *                                                                            *
 * likely and unlikely                                                        *
 *                                                                            *
 *  from glibc and kernel                                                     *
 *                                                                            *
\*****************************************************************************/
/* glic version  */
#if __GNUC__ >= 3
# define __glibc_unlikely(cond)	__builtin_expect ((cond), 0)
# define __glibc_likely(cond)	__builtin_expect ((cond), 1)
#else
# define __glibc_unlikely(cond)	(cond)
# define __glibc_likely(cond)	(cond)
#endif

/* kernel version  */
# define likely(x)	__builtin_expect(!!(x), 1)
# define unlikely(x)	__builtin_expect(!!(x), 0)

/*****************************************************************************\
 *                                                                            *
 * noreturn                                                                   *
 *                                                                            *
 *  from glibc and kernel                                                     *
 *                                                                            *
\*****************************************************************************/
#define __noreturn	__attribute__((noreturn))

#define __pure			__attribute__((pure))
#define __aligned(x)		__attribute__((aligned(x)))
#define __printf(a, b)		__attribute__((format(printf, a, b)))
#define __scanf(a, b)		__attribute__((format(scanf, a, b)))
#define __attribute_const__	__attribute__((__const__))
#define __maybe_unused		__attribute__((unused))
#define __always_unused		__attribute__((unused))

/**
 * examples: from kernel
 */
void __noreturn cpu_die(void)
{
	idle_task_exit();
	pcpu_sigp_retry(pcpu_devices + smp_processor_id(), SIGP_STOP, 0);

	for (;;) ;
}

/*****************************************************************************\
 *                                                                            *
 * variable-argument template                                                 *
 * va_list va_start and va_arg use template                                   *
 *                                                                            *
 *  from glibc                                                                *
 *                                                                            *
\*****************************************************************************/
mqd_t __mq_open (const char *name, int oflag, ...)
{
	if (name[0] != '/')
		return INLINE_SYSCALL_ERROR_RETURN_VALUE (EINVAL);

	mode_t mode = 0;
	struct mq_attr *attr = NULL;
	if (oflag & O_CREAT)
	{
		va_list ap;

		va_start (ap, oflag);
		mode = va_arg (ap, mode_t); /* get argv[2]:mode_t type */
		attr = va_arg (ap, struct mq_attr *); /* get argv[3]:mq_attr * type */
		va_end (ap); /* must have va_end?  */
	}

	return INLINE_SYSCALL (mq_open, 4, name + 1, oflag, mode, attr);
}

/*****************************************************************************\
 *                                                                            *
 * no idea                                                                    *
 *                                                                            *
 *  from glibc and kernel                                                     *
 *                                                                            *
\*****************************************************************************/
