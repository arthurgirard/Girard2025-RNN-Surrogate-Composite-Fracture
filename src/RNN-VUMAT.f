         subroutine VUMAT(
C Read_only
     1     nblock, ndir, nshr, nstatev, nfieldv, nprops, lanneal,
     2     stepTime, totalTime, dt, cmname, coordMp, charLength,
     3     props, density, strainInc, relSpinInc,
     4     tempOld, stretchOld, defgradOld, fieldOld,
     5     stressOld, stateOld, enerInternOld, enerInelasOld,
     6     tempNew, stretchNew, defgradNew, fieldNew,
C Write_only
     7     stressNew, stateNew, enerInternNew, enerInelasNew)
!
!
!------------------------------------------------------------------
      include 'vaba_param.inc'
C
      dimension props(nprops), density(nblock), coordMp(nblock,*),
     1  charLength(nblock), strainInc(nblock,ndir+nshr),
     2  relSpinInc(nblock,nshr), tempOld(nblock),
     3  stretchOld(nblock,ndir+nshr),
     4  defgradOld(nblock,ndir+nshr+nshr),
     5  fieldOld(nblock,nfieldv), stressOld(nblock,ndir+nshr),
     6  stateOld(nblock,nstatev), enerInternOld(nblock),
     7  enerInelasOld(nblock), tempNew(nblock),
     8  stretchNew(nblock,ndir+nshr),
     8  defgradNew(nblock,ndir+nshr+nshr),
     9  fieldNew(nblock,nfieldv), 
     1  stressNew(nblock,ndir+nshr), stateNew(nblock,nstatev),
     2  enerInternNew(nblock), enerInelasNew(nblock)
C
C     ToDO> replace int number by the int parameters 
      character*80 cmname, cr
      integer, parameter :: width = 50, units = 5, comp=4
      integer, parameter :: compplusunit = 8, DimDamage=1
      real*8, parameter :: Gamma_stress = 0.1
      real*8, dimension(width,compplusunit) :: wa1,wb1
      real*8, dimension(width) :: ba1,bb1
      real*8, dimension(width,width) :: wda2,wdb2
      real*8, dimension(width,width) :: wda3,wdb3
      real*8, dimension(width,width) :: wda4,wdb4
      real*8, dimension(width) :: bda2,bdb2
      real*8, dimension(width) :: bda3,bdb3
      real*8, dimension(width) :: bda4,bdb4
      real*8, dimension(width) :: outswa_1,outswb_1
      real*8, dimension(width) :: outswa_2,outswb_2
      real*8, dimension(width) :: outswa_3,outswb_3 
      real*8, dimension(width) :: outswa_4,outswb_4
      real*8, dimension(width) :: wout5, outswa, tainsw, bd
      real*8, dimension(width) :: tainsw_1,tainsw_2
      real*8, dimension(width) :: tainsw_3,tainsw_4
      real*8, dimension(width) :: b, aMul_01, aMul_02, outswb
      real*8, dimension(width) :: wout2,aMul_02_1
      real*8, dimension(width,width) :: wout3,wd
      real*8, dimension(units) :: bout,bfandh,xf,xh, newsts,xf_anorm
      real*8, dimension(units) :: minus_one_xf_anorm,xf_anorm_exp
      real*8, dimension(width,units) :: wout,wout1,wout0,wout4
      real*8, dimension(comp,comp) :: DDSDDE, amtrans
      real*8, dimension(comp) :: outs_b4_norm
      real*16, dimension(comp) :: aains,aainsr,outs,outsr,damp 
      real*8, dimension(compplusunit) :: tains
      real*8, dimension(width,compplusunit) :: w 
      real*8, dimension(units,width) :: wfandh 
C     -------------------------------------------   
C     Model definition Layer Stress 0-1
      real*8, dimension(comp,units) :: stress_dense,stress_dense_1
      real*8, dimension(width) :: stress_dense_biais
      real*8, dimension(width) :: stress_dense_1_biais
      real*8, dimension(width) :: outsr2 , outsr1_1, outsr1_2
C     Model definition Layer Stress 2-3  
      real*8, dimension(width,width) :: stress_dense_2,stress_dense_3
      real*8, dimension(width) :: stress_dense_2_biais
      real*8, dimension(width) :: stress_dense_3_biais
      real*8, dimension(width) :: outsr3 , outsr2_1, outsr2_2
C     Model definition Layer Stress 4-5  
      real*8, dimension(width,width) :: stress_dense_4,stress_dense_5
      real*8, dimension(width) :: stress_dense_4_biais
      real*8, dimension(width) :: stress_dense_5_biais
      real*8, dimension(width) :: outsr4 , outsr3_1, outsr3_2
C     Model definition Layer Stress 6-7  
      real*8, dimension(width) :: outsr5 , outsr4_1, outsr4_2     
      real*8, dimension(width,width) :: stress_dense_6,stress_dense_7
      real*8, dimension(width) :: stress_dense_7_biais,stress_dense_6_biais
C     Model definition Layer Stress 8
      real*8, dimension(comp,width) :: stress_dense_8
C     Model definition Layer Stress Output
      real*8, dimension(comp,width) :: stress_output_layer
C     -------------------------------------------       
C     Layer Damage
C     -------------------------------------------   
C     Dense 9 and 10
      real*8, dimension(width, units) :: damage_dense_9,damage_dense_10
      real*8, dimension(width) :: outDam_1, outDam_2,outDam_1_out
      real*8, dimension(width) :: outDam_2_out, outDam1, outDam9_10
C     Dense 11 and 12
      real*8, dimension(width, width) :: damage_dense_11,damage_dense_12
      real*8, dimension(width) :: outDam_3,outDam_3_out
      real*8, dimension(width) :: outDam_4,outDam_4_out, outDam11_12
C     Dense 13 and 14
      real*8, dimension(width, width) :: damage_dense_14
      real*8, dimension(width) :: outDam_5,outDam_5_out
      real*8, dimension(width) :: outDam_6,outDam_6_out, outDam13_14
C     Dense 15 and 16
      real*8, dimension(width, width) :: damage_dense_15,damage_dense_16
      real*8, dimension(width) :: outDam_7,outDam_7_out
      real*8, dimension(width) :: outDam_8,outDam_8_out, outDam15_16
C     Dense 17
      real*8, dimension(DimDamage,width) :: damage_dense_13
C     Output Layer Damage     
      real*8, dimension(DimDamage) :: DamOutput,DamOutput_out
C     Output Layer
      real*8, dimension(comp) :: StressOutput
      real*8, dimension(comp,comp) :: amtransout
C     -------------------------------------------   
      real*8, dimension(units) :: sts,sts_minusxh,newsts_noadd
      real*8 ansts, anorm,Y,n,lambda,mu,sigm
      real*8 E, XNU, TWOMU, THREMU, SIXMU, ALAMDA, TERM, CON1
      DIMENSION ansts(nstatev)
      parameter(zero = 0., one = 1., two = 2., three = 3.,
     1  third = one/three, half = .5, twoThirds = two/three,
     2  threeHalfs = 1.5, minus_one = -1. )
C initialisation if first increment
      do 100, km = 1,nblock
C material properties
      E = 3100.0D0
      XNU = 0.3
      TWOMU = E / (1.0D0 + XNU)
      THREMU = 3.0D0 / 2.0D0 * TWOMU
      SIXMU = 3.0D0 * TWOMU
      ALAMDA = TWOMU * (E - TWOMU) / (SIXMU - 2.0D0 * E)
      TERM = 1.0D0 / (TWOMU * (1.0D0 + HARD / THREMU))
      CON1 = SQRT(2.0D0 / 3.0D0)
      IF ((totalTime .eq. 0.0).and.(stepTime .eq. 0.0)) THEN
         DO I = 1, NBLOCK
            ! Compute trial stress
            TRACE = STRAININC(I, 1) + STRAININC(I, 2) + STRAININC(I, 3)
            STRESSNEW(I, 1) = STRESSOLD(I, 1) + ALAMDA * TRACE + 
     1      2.0D0 * TWOMU * STRAININC(I, 1)
            STRESSNEW(I, 2) = STRESSOLD(I, 2) + ALAMDA * TRACE + 
     1      2.0D0 * TWOMU * STRAININC(I, 2)
            STRESSNEW(I, 3) = STRESSOLD(I, 3) + ALAMDA * TRACE + 
     1      2.0D0 * TWOMU * STRAININC(I, 3)
            STRESSNEW(I, 4) = STRESSOLD(I, 4) + 
     1      2.0D0 * TWOMU * STRAININC(I, 4)
            STRESSNEW(I, 5) = STRESSOLD(I, 5) + 
     1      2.0D0 * TWOMU * STRAININC(I, 5)
            STRESSNEW(I, 6) = STRESSOLD(I, 6) + 
     1      2.0D0 * TWOMU * STRAININC(I, 6)
         END DO
        do I=1,nstatev-1
            stateOld(km, I) = zero
        end do
        stateOld(km, nstatev) = 1.d0
        do I=1,units
            sts(I) = zero
        end do
        do J=1, comp
            aains(J) = zero
        end do 
      goto 100
      END IF
      outs(1) = stressOld(km, 1)
      outs(2) = stressOld(km, 2)
      outs(3) = stressOld(km, 3)
C     outs(4) = stressOld(km, 4)
C     outs(5) = stressOld(km, 5)
C     outs(6) = stressOld(km, 6)
      aains(1) = strainInc(km, 1)
      aains(2) = strainInc(km, 2)
      aains(3) = strainInc(km, 4)
C     aains(1) = strainInc(km, 1)
C     if (abs(aains(1)) > 0.1) aains(1) = 0.0
C     aains(2) = strainInc(km, 2)
C     if (abs(aains(2)) > 0.1) aains(2) = 0.0
C     aains(3) = strainInc(km, 4)
C     if (abs(aains(3)) > 0.1) aains(3) = 0.0
C     aains(4) = strainInc(km, 4)
C     aains(5) = strainInc(km, 5)
C     aains(6) = strainInc(km, 6)
C     DO i = 1, 6
C     END DO 
C     give the expected result
C     do I=1,comp
C       sts(I) = aains(I)
C     end do
      sts(1) = stateOld(km, 4)
      sts(2) = stateOld(km, 5)
      sts(3) = stateOld(km, 6)
      sts(4) = stateOld(km, 7)
      sts(5) = stateOld(km, 8)
C     INCLUDE 'treat_ains.f'
C     anorm = NORM2(aains)
      anorm = sqrt(aains(1)**2 + aains(2)**2 + aains(3)**2)
      stateNew(km,9) = anorm
      IF (anorm .NE. 0.d0) aains = aains/anorm
C     CALL XPLB_ABQERR(1,'anorm  after_LMSC %R',,anorm,)
      tains(1) = aains(1)
      tains(2) = aains(2)
      tains(3) = aains(3)
      stateNew(km,1) = tains(1)
      stateNew(km,2) = tains(2)
      stateNew(km,3) = tains(3)
C     tains(4) = aains(4)
C     tains(5) = aains(5)
C     tains(6) = aains(6)
C     PRINT *, "Values of aains:"
      tains(4) = sts(1)
      tains(5) = sts(2)
      tains(6) = sts(3)
      tains(7) = sts(4)
      tains(8) = sts(5)
C     tains_good_result     
C treated_inputs_a
      cr = char(13)
      INCLUDE 'lmscc_wa_1.f'
      outswa_1 = MATMUL(wa1,tains) + ba1
      INCLUDE 'lmscc_wb_1.f'
C treated_inputs_b
      outswb_1 = MATMUL(wb1,tains) + bb1
      tainsw_1 = TANH(outswa_1)*TANH(outswb_1)
C     
      INCLUDE 'lmscc_wa_2.f'
      outswa_2 = MATMUL(wda2,tainsw_1) + bda2   
      INCLUDE 'lmscc_wb_2.f'
      outswb_2 = MATMUL(wdb2,tainsw_1) + bdb2
      tainsw_2 = TANH(outswa_2)*TANH(outswb_2)     
C  
C   ! forget and update
      INCLUDE 'lmscc_f.f'
      xf = MATMUL(wfandh,tainsw_2) + bfandh
      xf = EXP(xf)
      INCLUDE 'lmscc_u.f'
      xh = MATMUL(wfandh,tainsw_2) + bfandh
      xh = TANH(xh)
      newsts = EXP((-1.0)*xf*anorm)*(sts-xh)+xh
C Model_Stress_INCLUDES
      INCLUDE 'stress_dense.f'
C*****************************************************
C     Model- Stress to define dense_Mul,dense_1_Mul  with the dims of dense_1_biais
C*****************************************************   
C*****************************************************
C     Model- Stress
C*****************************************************          
      StressOutput = MATMUL(stress_dense, newsts)
C*****************************************************
C     Model_1 - Damage
C*****************************************************  
C     Artifficial_damping On stress
C------------------------------------------------      
      damp(1) = tains(1)*TANH(Gamma_stress*anorm/dt)/87.0
      damp(2) = tains(2)*TANH(Gamma_stress*anorm/dt)/90.0
      damp(3) = tains(3)*TANH(Gamma_stress*anorm/dt)/27.0
C------------------------------------------------       
C-------------------------------------------------
C     Artifficial_damping On Damage NOT ACTIVATED
C------------------------------------------------    
C     outsrdmg4(1) = outsrdmg4(1)+TANH((1/Gamma_damage)*anorm/dt)
! treat outputs
      outs_b4_norm(1)=StressOutput(1)
      outs_b4_norm(2)=StressOutput(2)
      outs_b4_norm(3)=StressOutput(3)
      ! Print each value of outs_b4_norm
C     PRINT *, "Values of outs_b4_norm:"
C     DO i = 1, 4
C         PRINT *, "outs_b4_norm(", i, ") = ", outs_b4_norm(i)
C     END DO 
C     INCLUDE 'treat_outs'
      stateNew(km,11) = damp(1)
      stateNew(km,12) = damp(2)
      stateNew(km,13) = damp(3)
C------------------------------------------------
C     DO i = 1, 3
C         PRINT *, "outs_b4_norm(", i, ") = ", outs_b4_norm(i)
C     END DO 
      outs(1) = outs_b4_norm(1)*87.55 - 6.355 + damp(1)
      outs(2) = outs_b4_norm(2)*90.37 - 7.054 + damp(2)
      outs(3) = outs_b4_norm(3)*27.12 - 0.459 + damp(3)
C     DO i = 1, 3
C         PRINT *, "outs(", i, ") = ", outs(i)
C     END DO 
C     outs(1) = outs_b4_norm(1) + damp(1)
C     outs(2) = outs_b4_norm(2) + damp(2)
C     outs(3) = outs_b4_norm(3) + damp(3)
C-------------------------------------------------     
      stressNew(km,1) = outs(1)
      stressNew(km,2) = outs(2)
      stressNew(km,3) = 0.0
      stressNew(km,4) = outs(3)
C-------------------------------------------------
      stateNew(km,4) = newsts(1)
      stateNew(km,5) = newsts(2)
      stateNew(km,6) = newsts(3)
      stateNew(km,7) = newsts(4)
      stateNew(km,8) = newsts(5)
C-------------------------------------------------
C     Saving Damage to StateVariable     
C     not larger than 1.0 and also not negative
      stateNew(km,10) = min( max( StressOutput(4)*1.0528d0 , 0.0d0 ), 1.0d0 )
C-------------------------------------------------
C     SDV15 controls element deletion flag  
      if (stateNew(km,10) < 1.0d0) then
          stateNew(km,15) = 1.0d0
      else
          stateNew(km,15) = 0.0d0
      end if
  100   CONTINUE 
!------end_Subroutine_VUMAT
      RETURN
      END subroutine VUMAT

      SUBROUTINE relu_vec(x, y, n)
      IMPLICIT NONE
      INTEGER, INTENT(IN) :: n
      REAL*8, INTENT(IN)  :: x(n)
      REAL*8, INTENT(OUT) :: y(n)
      INTEGER :: i

      DO i = 1, n
         IF (x(i) < 0D0) THEN
            y(i) = 0D0
         ELSE
            y(i) = x(i)
         ENDIF
      END DO

      END SUBROUTINE relu_vec
