! Copyright (c) 2017, Science and Technology Facilities Council
! 
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met:
! 
! * Redistributions of source code must retain the above copyright notice, this
!   list of conditions and the following disclaimer.
! 
! * Redistributions in binary form must reproduce the above copyright notice,
!   this list of conditions and the following disclaimer in the documentation
!   and/or other materials provided with the distribution.
! 
! * Neither the name of the copyright holder nor the names of its
!   contributors may be used to endorse or promote products derived from
!   this software without specific prior written permission.
! 
! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
! AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
! IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
! DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
! FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
! DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
! SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
! CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
! OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
! OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

! Author R. Ford STFC Daresbury Lab

module testkern_multi_anyw2_basis_mod
  use argument_mod
  use kernel_mod
  !
  type, extends(kernel_type) :: testkern_multi_anyw2_basis_type
     type(arg_type), dimension(3) :: meta_args = &
          (/ arg_type(gh_field,gh_write,any_w2), &
             arg_type(gh_field,gh_read, any_w2), &
             arg_type(gh_field,gh_read, any_w2)  &
           /)
     type(func_type), dimension(1) :: meta_funcs = &
          (/ func_type(any_w2,gh_basis,gh_diff_basis) /)
     integer :: iterates_over = cells
     integer :: gh_shape = gh_quadrature_XYoZ
   contains
     procedure, nopass :: code => testkern_multi_anyw2_basis_code
  end type testkern_multi_anyw2_basis_type
  !
contains
  !
  subroutine testkern_multi_anyw2_basis_code(nlayers, f1, f2, f3, &
                             ndf_any_w2, undf_any_w2, map_any_w2, &
                             basis_any_w2, diff_basis_any_w2,     &
                             nqp_h, nqp_v, wh, wv)
    use constants_mod, only: r_def
    implicit none
    integer :: nlayers, ndf_any_w2, undf_any_w2, nqp_h, nqp_v
    integer, dimension(:) :: map_any_w2
    real(kind=r_def), dimension(:) :: f1, f2, f3
    real(kind=r_def), dimension(:,:,:,:) :: basis_any_w2, diff_basis_any_w2
    real(kind=r_def), dimension(:) :: wh, wv
  end subroutine testkern_multi_anyw2_basis_code
  !
end module testkern_multi_anyw2_basis_mod
