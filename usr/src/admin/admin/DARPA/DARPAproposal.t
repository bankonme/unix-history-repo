.\"	@(#)DARPAproposal.t	1.1	87/01/29
.rm CM
.ce 1
\fB\s+2Proposal for Continued UNIX Research at Berkeley\s-2\fP
.sp
.ce 1
\fISummary\fP
.PP
The release of 4.3BSD in April of 1986 addressed many of the 
performance problems and unfinished interfaces
present in 4.2BSD [Leffler84] [McKusick85].
Berkeley has now embarked on a new development phase to likewise
update other old parts of the system.
There are three main areas of work.
The first is to provide a standard interface to file systems
so that multiple local and remote file systems can be supported
much as multiple networking protocols are by 4.3BSD.
The second is to rewrite the virtual memory system to take
advantage of current technology and to provide new capabilities
such as mapped files and shared memory.
Finally, there is a need to provide more internal flexibility in a
way similar to the System V Streams paradigm.
.NH
UNIX Research at Berkeley
.PP
Since the release of 4.3BSD in mid 1986,
we have begun work on three major new areas of research.
The decision on what our next areas of investigation should be were
drawn from discussions at the last steering committee meeting held
in the summer of 1985, and from later discussions held at
the annual Berkeley UNIX workshops.
Our goal is to apply leading edge research ideas into a stable
and reliable implementation that solves current problems in
distributed systems research.
.NH 2
Toward a Compatible File System Interface
.PP
The most critical shortcoming of our current UNIX system is in the
area of distributed file systems.
As with networking protocols,
there is no single distributed file system
that provides enough speed and functionality for all problems.
It is frequently necessary to support several different distributed
file system protocols, just as it is necessary to run several 
different network protocols.
.PP
As network or remote file systems have been implemented for UNIX,
several stylized interfaces between the file system implementation
and the rest of the kernel have been developed.
Among these are Sun Microsystems' Virtual File System interface (VFS)
using \fBvnodes\fP [Sandburg85] [Kleiman86],
Digital Equipment's Generic File System (GFS) architecture [Rodriguez86],
AT&T's File System Switch (FSS) [Rifkin86],
the LOCUS distributed file system [Walker85],
and Masscomp's extended file system [Cole85].
Other remote file systems have been implemented in research or
university groups for internal use \-
notably the network file system in the Eighth Edition UNIX
system [Weinberger84] and two different file systems used at Carnegie Mellon
University [Satyanarayanan85].
Numerous other remote file access methods have been devised for use
within individual UNIX processes,
many of them by modifications to the C I/O library
similar to those in the Newcastle Connection [Brownbridge82].
.PP
Each design attempts to isolate file system-dependent details
below a generic interface and to provide a framework within which
new file systems may be incorporated.
However, each of these interfaces is different from
and is incompatible with the others.
Each addresses somewhat different design goals,
having been based on a different starting version of UNIX,
having targeted a different set of file systems with varying characteristics,
and having selected a different set of file system primitive operations.
.PP
Our work is aimed at providing a common framework to simultaneously
support these different distributed file systems rather than to
simply implement yet another protocol.
This requires a detailed study of the existing protocols, 
and discussion with their implementors to determine whether
they can modify their implementation to fit within our proposed framework.
We have studied the various file system interfaces to determine
their generality, completeness, robustness, efficiency, and aesthetics.
Based on this study, we have developed a proposal for a new
file system interface that we believe includes the best features of
each of the existing implementations.
This proposal and the rationale underlying its development
have been presented to major software vendors as an early step
toward convergence on a compatible file system interface.
Briefly, the proposal adopts the 4.3BSD calling convention for name lookup,
but otherwise is closely related to Sun's VFS [Karels86].
.PP
A prototype implementation now is being developed.
We expect that this work will be finished in time for a release at the
end of the current contract if that is deemed desirable.
.NH
Future Projects
.PP
The virtual memory and stream protocol research are longer term projects
that we would expect would be done as part of a follow on contract.
The virtual memory work uses many new and untested ideas that will
require extensive experience to insure that they work well in a wide range
of environments.
It is our expectation that this work would be ready for release towards
the end of the follow on contract.
.NH 2
A New Virtual Memory Implementation
.PP
With the cost per byte of memory approaching that of the cost per byte
for disks, and with file systems increasingly removed from host
machines, a new approach to the implementation of virtual memory is
necessary. In 4.3BSD the swap space is preallocated;
this limits the maximum virtual memory that can be
supported to the size of the swap area [Babaoglu79] [Someren84].
The new system should support virtual memory space at least as great as
the sum of sizes of physical memory plus swap space
(a system may run with no swap space if it has no local disk).
For systems that have a local swap
disk, but use remote file systems,
using some memory to keep track of the contents of swap space
may be useful to avoid multiple fetches
of the same data from the file system.
.PP
The new implementation should also add new functionality.  Processes
should be allowed to have large sparse address spaces, to map files
into their address spaces, to map device memory into their address
spaces, and to share memory with other processes. The shared address
space may either be obtained by mapping a file into (possibly
different) parts of the address space, or by arranging for processes to
share ``anonymous memory'' (that is, memory that is zero-fill on demand, and
whose contents are lost when the last process unmaps the memory).
This latter approach was the one adopted by the developers of System V.
.PP
One possible use of shared memory is to provide a high-speed
Inter-Process Communication (IPC) mechanism between two or more
cooperating processes. To insure the integrity of data structures
in a shared region, processes must be able to use semaphores to
coordinate their access to these shared structures. In System V,
semaphores are provided as a set of system calls. Unfortunately,
the use of system calls reduces the throughput of the shared memory
IPC to that of existing IPC mechanisms.
To avoid this bottleneck,
we expect that the next release of BSD will incorporate a scheme
that places the semaphores in the shared memory segment, so that
machines with a test-and-set instruction will be able to handle the usual
uncontested ``lock'' and ``unlock'' without doing two system calls.
Only in the unusual case of trying to lock an already-locked lock or when
a desired lock is being released will a system call be required.  The
interface will allow a user-level implementation of the System V semaphore
interface on most machines with a much lower runtime cost [McKusick86].
.PP
We have maintained an active mailing list to discuss
the issues of the user interface to the virtual memory system\(dg.
.FS
\(dgParticipants in the mailing list include:
Mike Karels and Kirk McKusick (CSRG),
Avadis Tevanian (Carnegie-Mellon Univ, MACH Project),
Dennis Ritchie (AT&T Bell Labs),
Robert Elz (Univ of Melbourne),
Michael L. Powell (DEC Western Research),
Bill Shannon, Rob Gingell, Dan Walsh, and Joe Moran (Sun Microsystems),
Tom Watson and Jim Mankovich (Convex),
Gregory Depp (DEC Ultrix Engineering),
Ron Gomes (AT&T Information Systems),
David C. Stewart (Sequent),
Jack A. Test and Herb Jacobs (Alliant),
Steve Gaede (NBI),
Jim Lipkis (New York Univ),
Stephen J. Hartley (Univ of Vermont),
Hermann Haertig (Univ in Germany),
Alan Sexton (Univ in Germany),
Jukka Virtanen (Univ in Finland)
.FE
Within the last few months, the specification of the interface has been
agreed on.
The next step is to design an implementation for this interface.
There are several groups that have recently done
virtual memory implementations, including several major UNIX vendors
as well as groups in academic environments.
The academic work is most interesting to us because the source
code is unencumbered by licensing restrictions making it readily
available for our direct incorporation.
The most promising of this work is that done as part of the MACH
project since it can easily be extended to provide the
services described for our user interface [Accetta86].
.NH 2
Changes to the Protocol Layering Interface
.PP
The original work on restructuring the UNIX character I/O system
to allow flexible configuration of the internal modules by user
processes was done at Bell Laboratories [Ritchie84].
Known as stackable line disciplines, these interfaces allowed a user
process to open a raw terminal port and then push on appropriate
processing modules (such as one to do line editing).
This model allowed terminal processing modules to be used with
virtual-circuit network modules to create ``network virtual terminals''
by stacking a terminal processing module on top of a
networking protocol.
.PP
The design of the networking facilities for 4.2BSD took
a different approach based on the \fBsocket\fP interface.
This design allows a single system to support multiple sets of networking
protocols with stream, datagram, and other types of access.
Protocol modules may deal with multiplexing of data from different connections
onto a single transport medium.
.PP
A problem with stackable line disciplines though, is that they
are inherently linear in nature.
Thus, they do not adequately model the fan-in and fan-out
associated with multiplexing.
The simple and elegant stackable line discipline implementation
of Eighth Edition UNIX was converted to the full production implementation
of Streams in System V Release 3.
In doing the conversion, many pragmatic issues were addressed,
including the handling of
multiplexed connections and commercially important protocols.
Unfortunately, the implementation complexity increased enormously.
.PP
Because AT&T will not allow others to include Streams unless they
also change their interface to comply with the System V Interface Definition
base and Networking Extension,
we cannot use the Release 3 implementation of Streams in the Berkeley system.
Given that compatibility thus will be difficult,
we feel we will have complete freedom to make our
choices based solely on technical merits.
As a result, our implementation will appear far more like the simpler stackable
line disciplines than the more complex Release 3 Streams [Chandler86].
A socket interface will be used rather than a character device interface,
and demultiplexing will be handled internally by the protocols in the kernel.
However, like Streams, the interfaces between kernel
protocol modules will follow a uniform convention.
.NH
References
.sp
.IP Accetta86 \w'Satyanarayanan85\0\0'u
Accetta, M., R. Baron, W. Bolosky, R. Rashid, A. Tevanian, M. Young,
``MACH: A New Foundation for UNIX Development''
Computer Science Department, Carnegie-Mellon University, Pittsburg, PA 15213,
April 1986.
.sp
.IP Babaoglu79
Babaoglu, O., W. Joy,
``Data Structures Added in the Berkeley Virtual Memory Extensions
to the UNIX Operating System''
Computer Systems Research Group, Dept of EECS, University of California,
Berkeley, CA 94720, USA, November 1979.
.sp
.IP Brownbridge82
Brownbridge, D.R., L.F. Marshall, B. Randell,
``The Newcastle Connection, or UNIXes of the World Unite!,''
\fISoftware\- Practice and Experience\fP, Vol. 12, pp. 1147-1162, 1982.
.sp
.IP Chandler86
Chandler, D.,
``The Monthly Report \- Up the Streams Without a Standard'',
\fIUNIX Review\fP, Vol. 4, No. 9, pp. 6-14, September 1986.
.sp
.IP Cole85
Cole, C.T., P.B. Flinn, A.B. Atlas,
``An Implementation of an Extended File System for UNIX,''
\fIUsenix Conference Proceedings\fP,
pp. 131-150, June, 1985.
.sp
.IP Karels86
Karels, M., M. McKusick,
``Towards a Compatible File System Interface,''
\fIProceedings of the European UNIX Users Group Meeting\fP,
Manchester, England, pp. 481-496, September 1986.
.sp
.IP Kleiman86
Kleiman, S.,
``Vnodes: An Architecture for Multiple File System Types in Sun UNIX,''
\fIUsenix Conference Proceedings\fP,
pp. 238-247, June, 1986.
.sp
.IP Leffler84
Leffler, S., M.K. McKusick, M. Karels,
``Measuring and Improving the Performance of 4.2BSD,''
\fIUsenix Conference Proceedings\fP, pp. 237-252, June, 1984.
.sp
.IP McKusick85
McKusick, M.K., M. Karels, S. Leffler,
``Performance Improvements and Functional Enhancements in 4.3BSD,''
\fIUsenix Conference Proceedings\fP, pp. 519-531, June, 1985.
.sp
.IP McKusick86
McKusick, M., M. Karels,
``A New Virtual Memory Implementation for Berkeley UNIX,''
\fIProceedings of the European UNIX Users Group Meeting\fP,
Manchester, England, pp. 451-460, September 1986.
.sp
.IP Someren84
Someren, J. van,
``Paging in Berkeley UNIX,''
Laboratorium voor schakeltechniek en techneik v.d. 
informatieverwerkende machines,
Codenummer 051560-44(1984)01, February 1984.
.sp
.IP Rifkin86
Rifkin, A.P., M.P. Forbes, R.L. Hamilton, M. Sabrio, S. Shah, K. Yueh,
``RFS Architectural Overview,'' \fIUsenix Conference Proceedings\fP,
pp. 248-259, June, 1986.
.sp
.IP Ritchie74
Ritchie, D.M., K. Thompson,
``The Unix Time-Sharing System,''
\fICommunications of the ACM\fP, Vol. 17, pp. 365-375, July, 1974.
.sp
.IP Rodriguez86
Rodriguez, R., M. Koehler, R. Hyde,
``The Generic File System,''
\fIUsenix Conference Proceedings\fP,
pp. 260-269, June, 1986.
.sp
.IP Sandberg85
Sandberg, R., D. Goldberg, S. Kleiman, D. Walsh, B. Lyon,
``Design and Implementation of the Sun Network File System,''
\fIUsenix Conference Proceedings\fP,
pp. 119-130, June, 1985.
.sp
.IP Satyanarayanan85
Satyanarayanan, M., \fIet al.\fP,
``The ITC Distributed File System: Principles and Design,''
\fIProc. 10th Symposium on Operating Systems Principles\fP, pp. 35-50,
ACM, December, 1985.
.sp
.IP Walker85
Walker, B.J. and S.H. Kiser, ``The LOCUS Distributed File System,''
\fIThe LOCUS Distributed System Architecture\fP,
G.J. Popek and B.J. Walker, ed., The MIT Press, Cambridge, MA, 1985.
.sp
.IP Weinberger84
Weinberger, P.J., ``The Version 8 Network File System,''
\fIUsenix Conference presentation\fP,
June, 1984.
