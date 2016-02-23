      !-------------------------------------------------------------------------
      !  Module   :                  ppm_rc_module_util
      !-------------------------------------------------------------------------
      !  MOSAIC Group
      !  Max Planck Institute of Molecular Cell Biology and Genetics
      !  Pfotenhauerstr. 108, 01307 Dresden, Germany
      !
      !  Author           - y.afshar           June   2014
      !-------------------------------------------------------------------------
      MODULE ppm_rc_module_filter
        !----------------------------------------------------------------------
        !  Modules
        !----------------------------------------------------------------------
        USE ppm_rc_module_global
        IMPLICIT NONE

        PRIVATE
        !----------------------------------------------------------------------
        !  Some work memory on the heap
        !----------------------------------------------------------------------
        CLASS(ppm_t_field_), POINTER :: fld1
        CLASS(ppm_t_field_), POINTER :: fld2

        REAL(MK), DIMENSION(:),         ALLOCATABLE :: tmp1_r
        REAL(MK), DIMENSION(:,:),       ALLOCATABLE :: tmp2_r
        REAL(MK), DIMENSION(:,:,:),     ALLOCATABLE :: tmp3_r
        REAL(MK), DIMENSION(:,:,:,:),   ALLOCATABLE :: tmp4_r

        REAL(ppm_kind_double), DIMENSION(:), ALLOCATABLE :: tmp1_rd

        INTEGER, DIMENSION(:),         ALLOCATABLE :: tmp1_i
        INTEGER, DIMENSION(:,:),       ALLOCATABLE :: tmp2_i
        INTEGER, DIMENSION(:,:,:),     ALLOCATABLE :: tmp3_i
        INTEGER, DIMENSION(:,:,:,:),   ALLOCATABLE :: tmp4_i

        INTEGER,                       DIMENSION(1) :: ldc

#include "./filter/ppm_rc_filtertypedef.f"

        !----------------------------------------------------------------------
        !  Define module interfaces
        !----------------------------------------------------------------------
        INTERFACE convolve
          MODULE PROCEDURE ppm_rc_convolve_i_2d
          MODULE PROCEDURE ppm_rc_convolve_i_3d
          MODULE PROCEDURE ppm_rc_convolve_r_2d
          MODULE PROCEDURE ppm_rc_convolve_r_3d
        END INTERFACE

        INTERFACE GaussianCurvature_2d
          MODULE PROCEDURE ppm_rc_gc_2d
        END INTERFACE
        INTERFACE GaussianCurvature_3d
          MODULE PROCEDURE ppm_rc_gc_3d
        END INTERFACE

        INTERFACE median_2d
          MODULE PROCEDURE ppm_rc_median_2d
        END INTERFACE
        INTERFACE median_3d
          MODULE PROCEDURE ppm_rc_median_3d
        END INTERFACE

        INTERFACE GaussianImageFilter_2d
          MODULE PROCEDURE ppm_rc_GaussianImageFilter_2d
        END INTERFACE
        INTERFACE GaussianImageFilter_3d
          MODULE PROCEDURE ppm_rc_GaussianImageFilter_3d
        END INTERFACE

        INTERFACE SobelImageFilter_2d
          MODULE PROCEDURE ppm_rc_SobelImageFilter_2d
        END INTERFACE
        INTERFACE SobelImageFilter_3d
          MODULE PROCEDURE ppm_rc_SobelImageFilter_3d
        END INTERFACE

        INTERFACE EdgeDetection_2d
          MODULE PROCEDURE ppm_rc_EdgeDetection_2d
        END INTERFACE
        INTERFACE EdgeDetection_3d
          MODULE PROCEDURE ppm_rc_EdgeDetection_3d
        END INTERFACE
        !----------------------------------------------------------------------
        ! Public
        !----------------------------------------------------------------------
        !!! Gaussian curvature
        PUBLIC :: GaussianCurvature_2d
        PUBLIC :: GaussianCurvature_3d
        !!! Convolution or correlation
        PUBLIC :: convolve
        !!! Median
        PUBLIC :: median_2d
        PUBLIC :: median_3d
        !!!
        PUBLIC :: ThresholdImageFilter
        PUBLIC :: OtsuThresholdImageFilter

        PUBLIC :: GaussianImageFilter_2d
        PUBLIC :: GaussianImageFilter_3d

        PUBLIC :: SobelImageFilter_2d
        PUBLIC :: SobelImageFilter_3d

        PUBLIC :: EdgeDetection_2d
        PUBLIC :: EdgeDetection_3d

      CONTAINS

#define __2D  2
#define __3D  3

#define  DTYPE(a) a/**/_3d
#define __DIME  __3D
#include "./filter/ppm_rc_filtertypeproc.f"

#include "./filter/ppm_rc_gc.f"
#include "./filter/ppm_rc_median.f"
#define __TYPE INTEGER
#define  CTYPE(a) a/**/_i
#define __ZERO 0
#include "./filter/ppm_rc_convolve.f"
#undef __ZERO
#undef __TYPE
#undef CTYPE
#define __TYPE REAL(MK)
#define  CTYPE(a) a/**/_r
#define __ZERO zero
#include "./filter/ppm_rc_convolve.f"
#undef __ZERO
#undef __TYPE
#undef CTYPE
#define __ZERO zero
#include "./filter/ppm_rc_GaussianImageFilter.f"
#include "./filter/ppm_rc_SobelImageFilter.f"
#include "./filter/ppm_rc_EdgeDetection.f"
#undef __ZERO
#undef  __DIME
#undef  DTYPE


#define  DTYPE(a) a/**/_2d
#define __DIME  __2D
#include "./filter/ppm_rc_filtertypeproc.f"

#include "./filter/ppm_rc_gc.f"
#include "./filter/ppm_rc_median.f"
#define __TYPE INTEGER
#define __ZERO 0
#define  CTYPE(a) a/**/_i
#include "./filter/ppm_rc_convolve.f"
#undef __ZERO
#undef __TYPE
#undef CTYPE
#define __TYPE REAL(MK)
#define  CTYPE(a) a/**/_r
#define __ZERO zero
#include "./filter/ppm_rc_convolve.f"
#undef __ZERO
#undef __TYPE
#undef CTYPE
#define __ZERO zero
#include "./filter/ppm_rc_GaussianImageFilter.f"
#include "./filter/ppm_rc_SobelImageFilter.f"
#include "./filter/ppm_rc_EdgeDetection.f"
#undef __ZERO
#undef  __DIME
#undef  DTYPE

#undef  __2D
#undef  __3D

      END MODULE ppm_rc_module_filter