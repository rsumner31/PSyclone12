!-------------------------------------------------------------------------------
! (c) The copyright relating to this work is owned jointly by the Crown,
! Met Office and NERC 2014.
! However, it has been created with the help of the GungHo Consortium,
! whose members are identified at https://puma.nerc.ac.uk/trac/GungHo/wiki
!-------------------------------------------------------------------------------

!-------------------------------------------------------------------------------
! NAME
!   kernel_mod
!
! DESCRIPTION
!   The base type for a kernel. Also contains a component routine that returns a
!   launch object for use by the execution engine/code generator. 
!-------------------------------------------------------------------------------
module kernel_mod
use argument_mod
use global_parameters_mod
implicit none
private

public CELLS, EDGES, VERTICES, FE, DP, arg
public READ, WRITE, READWRITE, INC
public SUM, MIN, MAX
public CG, DG, R

!> These quantities should be defined somewhere in the lfric
!! infrastructure but at the moment they are not!
!! \todo Work out where POINTWISE and DOFS should be declared.
INTEGER, PARAMETER :: POINTWISE = 2, DOFS = 5
public POINTWISE, DOFS 

type :: kernel_type
  private
  logical :: no_op

end type kernel_type

!-------------------------------------------------------------------------------
! Expose public types
!-------------------------------------------------------------------------------

public :: kernel_type

  
end module kernel_mod



