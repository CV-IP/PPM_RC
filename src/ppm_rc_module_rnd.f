      !-------------------------------------------------------------------------
      !  Module       :                    ppm_rc_module_rnd
      !-------------------------------------------------------------------------
      !
      !  Purpose      : This module contains the random number generator and
      !                 related subroutines
      !
      !  Remarks      : In order to get different number one needs to initialize
      !                 using saru_random_init or mt_random_init
      !
      !  References   :
      !
      !  Revisions    :
      !-------------------------------------------------------------------------
      !  MOSAIC Group
      !  Max Planck Institute of Molecular Cell Biology and Genetics
      !  Pfotenhauerstr. 108, 01307 Dresden, Germany
      !
      !  Author           - y.afshar           June   2014
      !-------------------------------------------------------------------------

      MODULE ppm_rc_module_rnd
        !----------------------------------------------------------------------
        !  Modules
        !----------------------------------------------------------------------
        USE ppm_rc_module_global, ONLY : ppm_kind_double,ppm_char,rank,comm, &
        &   ppm_err_mpi_fail,ppm_error_error,ppm_err_sub_failed,ppm_error,   &
        &   substart,substop

        USE ISO_C_BINDING
        IMPLICIT NONE

        PRIVATE

        INTEGER :: iseed=0

        LOGICAL :: init=.FALSE.

        !----------------------------------------------------------------------
        !  Some work memory on the heap
        !----------------------------------------------------------------------
        !----------------------------------------------------------------------
        !  Define module interfaces
        !----------------------------------------------------------------------
        INTERFACE SaruInitialize
          FUNCTION SaruInitialize1(iseed) BIND(C,NAME='SaruInitialize1')
            IMPORT         :: C_INT
            INTEGER(C_INT) :: iseed
            INTEGER(C_INT) :: SaruInitialize1
          END FUNCTION
          FUNCTION SaruInitialize2() BIND(C,NAME='SaruInitialize2')
            IMPORT         :: C_INT
            INTEGER(C_INT) :: SaruInitialize2
          END FUNCTION
        END INTERFACE

        INTERFACE SaruGetIntegerVariate
          FUNCTION SaruGetIntegerVariate1(high) BIND(C,NAME='SaruGetIntegerVariate1')
            IMPORT         :: C_INT
            INTEGER(C_INT) :: high
            INTEGER(C_INT) :: SaruGetIntegerVariate1
          END FUNCTION
          FUNCTION SaruGetIntegerVariate2() BIND(C,NAME='SaruGetIntegerVariate2')
            IMPORT         :: C_INT
            INTEGER(C_INT) :: SaruGetIntegerVariate2
          END FUNCTION
        END INTERFACE

        INTERFACE SaruGetRealVariate
          FUNCTION SaruGetRealVariateS1() BIND(C,NAME='SaruGetRealVariateS1')
            IMPORT        :: C_FLOAT
            REAL(C_FLOAT) :: SaruGetRealVariateS1
          END FUNCTION
          FUNCTION SaruGetRealVariateS2(low,high) BIND(C,NAME='SaruGetRealVariateS2')
            IMPORT        :: C_FLOAT
            REAL(C_FLOAT) :: low
            REAL(C_FLOAT) :: high
            REAL(C_FLOAT) :: SaruGetRealVariateS2
          END FUNCTION
        END INTERFACE

        INTERFACE SaruGetRealVariateD
          FUNCTION SaruGetRealVariateD1() BIND(C,NAME='SaruGetRealVariateD1')
            IMPORT         :: C_DOUBLE
            REAL(C_DOUBLE) :: SaruGetRealVariateD1
          END FUNCTION
          FUNCTION SaruGetRealVariateD2(low,high) BIND(C,NAME='SaruGetRealVariateD2')
            IMPORT         :: C_DOUBLE
            REAL(C_DOUBLE) :: low
            REAL(C_DOUBLE) :: high
            REAL(C_DOUBLE) :: SaruGetRealVariateD2
          END FUNCTION
        END INTERFACE

        ! Constructs a discrete_distribution from a normalized image data
        ! the values of the image data represent weights for the possible values of the distribution
        INTERFACE GenerateImageDiscrDistr
          FUNCTION GenerateFloatImageDiscrDistr2D(sample,width,length) BIND(C,NAME='GenerateFloatImageDiscrDistr2D')
            IMPORT         :: C_INT,C_FLOAT
            INTEGER(C_INT) :: width
            INTEGER(C_INT) :: length
            REAL(C_FLOAT)  :: sample(width,length)
            INTEGER(C_INT) :: GenerateFloatImageDiscrDistr2D
          END FUNCTION
          FUNCTION GenerateDoubleImageDiscrDistr2D(sample,width,length) BIND(C,NAME='GenerateDoubleImageDiscrDistr2D')
            IMPORT         :: C_INT,C_DOUBLE
            INTEGER(C_INT) :: width
            INTEGER(C_INT) :: length
            REAL(C_DOUBLE) :: sample(width,length)
            INTEGER(C_INT) :: GenerateDoubleImageDiscrDistr2D
          END FUNCTION
          FUNCTION GenerateFloatImageDiscrDistr3D(sample,width,length,depth) BIND(C,NAME='GenerateFloatImageDiscrDistr3D')
            IMPORT         :: C_INT,C_FLOAT
            INTEGER(C_INT) :: width
            INTEGER(C_INT) :: length
            INTEGER(C_INT) :: depth
            REAL(C_FLOAT)  :: sample(width,length,depth)
            INTEGER(C_INT) :: GenerateFloatImageDiscrDistr3D
          END FUNCTION
          FUNCTION GenerateDoubleImageDiscrDistr3D(sample,width,length,depth) BIND(C,NAME='GenerateDoubleImageDiscrDistr3D')
            IMPORT         :: C_INT,C_DOUBLE
            INTEGER(C_INT) :: width
            INTEGER(C_INT) :: length
            INTEGER(C_INT) :: depth
            REAL(C_DOUBLE) :: sample(width,length,depth)
            INTEGER(C_INT) :: GenerateDoubleImageDiscrDistr3D
          END FUNCTION
        END INTERFACE

        ! Get the random index with probabilty of the values of the normalized image data
        ! Before calling this routine GenerateImageDiscrDistr should be called to create the
        ! ImageDiscrDistr
        INTERFACE GetImageDistrIndex
          FUNCTION GetImageDistrIndex() BIND(C,NAME='GetImageDistrIndex')
            IMPORT          :: C_LONG
            INTEGER(C_LONG) :: GetImageDistrIndex
          END FUNCTION
        END INTERFACE

        INTERFACE DestroyImageDiscrDistr
          FUNCTION DestroyImageDiscrDistr() BIND(C,NAME='DestroyImageDiscrDistr')
            IMPORT         :: C_INT
            INTEGER(C_INT) :: DestroyImageDiscrDistr
          END FUNCTION
        END INTERFACE

        INTERFACE GenerateParticlesFwdProposalsDiscrDistr
          FUNCTION GenerateFloatParticlesFwdProposalsDiscrDistr(sample,partsize) BIND(C,NAME='GenerateFloatParticlesFwdProposalsDiscrDistr')
            IMPORT         :: C_INT,C_FLOAT
            INTEGER(C_INT) :: partsize
            REAL(C_FLOAT)  :: sample(partsize)
            INTEGER(C_INT) :: GenerateFloatParticlesFwdProposalsDiscrDistr
          END FUNCTION
          FUNCTION GenerateDoubleParticlesFwdProposalsDiscrDistr(sample,partsize) BIND(C,NAME='GenerateDoubleParticlesFwdProposalsDiscrDistr')
            IMPORT         :: C_INT,C_DOUBLE
            INTEGER(C_INT) :: partsize
            REAL(C_DOUBLE) :: sample(partsize)
            INTEGER(C_INT) :: GenerateDoubleParticlesFwdProposalsDiscrDistr
          END FUNCTION
        END INTERFACE

        INTERFACE GetPartDistrIndex
          FUNCTION GetPartDistrIndex() BIND(C,NAME='GetPartDistrIndex')
            IMPORT         :: C_INT
            INTEGER(C_INT) :: GetPartDistrIndex
          END FUNCTION
        END INTERFACE

        INTERFACE DestroyParticlesDiscrDistr
          FUNCTION DestroyParticlesDiscrDistr() BIND(C,NAME='DestroyParticlesDiscrDistr')
            IMPORT         :: C_INT
            INTEGER(C_INT) :: DestroyParticlesDiscrDistr
          END FUNCTION
        END INTERFACE

        INTERFACE MTInitialize
          FUNCTION MTInitialize(iseed) BIND(C,NAME='MTInitialize')
            IMPORT         :: C_INT
            INTEGER(C_INT) :: iseed
            INTEGER(C_INT) :: MTInitialize
          END FUNCTION
        END INTERFACE

        !----------------------------------------------------------------------
        ! Public
        !----------------------------------------------------------------------
        PUBLIC :: saru_random_init
        PUBLIC :: SaruGetIntegerVariate
        PUBLIC :: SaruGetRealVariate
        PUBLIC :: SaruGetRealVariateD

        PUBLIC :: mt_random_init
        PUBLIC :: GenerateImageDiscrDistr
        PUBLIC :: GetImageDistrIndex
        PUBLIC :: DestroyImageDiscrDistr

        PUBLIC :: GenerateParticlesFwdProposalsDiscrDistr
        PUBLIC :: GetPartDistrIndex
        PUBLIC :: DestroyParticlesDiscrDistr

      CONTAINS
        !----------------------------------------------------------------------
        ! routine for setting the seed for the random no. generator in
        ! Saru pseudo random number generation
        !----------------------------------------------------------------------
        SUBROUTINE saru_random_init(info)
          !----------------------------------------------------------------------
          !  Modules
          !----------------------------------------------------------------------
          IMPLICIT NONE

          INTEGER, INTENT(  OUT) :: info

          REAL(ppm_kind_double) :: t0

          INTEGER :: ih,ic,im

          CHARACTER(LEN=ppm_char) :: caller='saru_random_init'

          !-------------------------------------------------------------------------
          !  Initialize
          !-------------------------------------------------------------------------
          CALL substart(caller,t0,info)

          SELECT CASE (init)
          CASE (.FALSE.)
             init=.TRUE.

             SELECT CASE (iseed)
             CASE (0)
                ! First random number seed must be between 0 and 31328
                ! Second seed must have a value between 0 and 30081
                CALL SYSTEM_CLOCK(ih,ic,im)
                iseed=MOD(ih+rank*rank,31328)

             END SELECT

             info=SaruInitialize(iseed)
             or_fail("Failed to Initialize SaruIntegerVariate!")

          CASE DEFAULT
             info=SaruInitialize()
             or_fail("Failed to Initialize SaruRealVariate!")

          END SELECT
        !-------------------------------------------------------------------------
        !  Return
        !-------------------------------------------------------------------------
        9999 CONTINUE
          CALL substop(caller,t0,info)
          RETURN
        END SUBROUTINE saru_random_init

        !----------------------------------------------------------------------
        ! routine for setting the seed for the random no. generator in
        ! mersenne_twister pseudo random number generation
        !----------------------------------------------------------------------
        SUBROUTINE mt_random_init(info)
          !----------------------------------------------------------------------
          !  Modules
          !----------------------------------------------------------------------
          USE ppm_module_mpi
          IMPLICIT NONE

          INTEGER, INTENT(  OUT) :: info

          REAL(ppm_kind_double) :: t0

          INTEGER :: ih,ic,im

          CHARACTER(LEN=ppm_char) :: caller='mt_random_init'

          !-------------------------------------------------------------------------
          !  Initialize
          !-------------------------------------------------------------------------
          CALL substart(caller,t0,info)

          SELECT CASE (iseed)
          CASE (0)
             ! First random number seed must be between 0 and 31328
             ! Second seed must have a value between 0 and 30081
             CALL SYSTEM_CLOCK(ih,ic,im)
             iseed=MOD(ih+rank*rank,31328)
          END SELECT

          info=MTInitialize(iseed)
          or_fail("Failed to Initialize MTInitialize!")

        !-------------------------------------------------------------------------
        !  Return
        !-------------------------------------------------------------------------
        9999 CONTINUE
          CALL substop(caller,t0,info)
          RETURN
        END SUBROUTINE mt_random_init
      END MODULE ppm_rc_module_rnd
