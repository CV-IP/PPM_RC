# ===========================================================================
#       http://www.nongnu.org/autoconf-archive/ax_f90_module_flag.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_FC_MODULE_FLAG
#
# DESCRIPTION
#
#   Find Fortran modules inclusion flag. The module inclusion flag is
#   stored in the cached variable ax_fc_modflag. An error is triggered if
#   the flag cannot be found. Supported are the -I GNU compilers flag, the
#   -M SUN compilers flag, and the -p Absoft Pro Fortran compiler flag.
#
#   Note (Omar Awile): I think GNU has a -J flag and Intel the -I flag.
# LICENSE
#
#   Copyright (c) 2009 Luc Maisonobe <luc@spaceroots.org>
#   Copyright (c) 2009 Julian C. Cummings <cummings@cacr.caltech.edu>
#   Copyright (c) 2009 Alexander Pletzer <pletzer@txcorp.com>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 11

AC_DEFUN([AX_FC_MODULE_FLAG],[
	AC_CACHE_CHECK([fortran modules inclusion flag],
		ax_cv_fc_modflag,
		[AC_LANG_PUSH(Fortran)
			i=0
			while test \( -f tmpdir_$i \) -o \( -d tmpdir_$i \) ; do
				i=`expr $i + 1`
			done
			mkdir tmpdir_$i
			cd tmpdir_$i
			AC_COMPILE_IFELSE([
				!234567
				module conftest_module
				contains
				subroutine conftest_routine
				write(*,'(a)') 'gotcha!'
				end subroutine conftest_routine
				end module conftest_module
				], [], []
			)

			cd ..
			ax_cv_fc_modflag="not found"
			for ax_flag in "-I" "-J" "-M" "-p"; do
				if test "$ax_cv_fc_modflag" = "not found" ; then
					ax_save_FCFLAGS="$FCFLAGS"
					FCFLAGS="$ax_save_FCFLAGS ${ax_flag}tmpdir_$i"
					AC_COMPILE_IFELSE([
						!234567
						program conftest_program
						use conftest_module
						call conftest_routine
						end program conftest_program
						],
						[ax_cv_fc_modflag="$ax_flag"],[]
					)
					FCFLAGS="$ax_save_FCFLAGS"
				fi
			done
			rm -fr tmpdir_$i

			if test "$ax_cv_fc_modflag" = "not found" ; then
  				AC_MSG_ERROR([unable to find compiler flag for modules inclusion])
			fi
			AC_LANG_POP(Fortran)
		]
	)]
) dnl AX_FC_MODULE_FLAG
