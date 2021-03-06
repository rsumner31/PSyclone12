! Modifications copyright (c) 2017, Science and Technology Facilities Council
!-------------------------------------------------------------------------------
! (c) The copyright relating to this work is owned jointly by the Crown,
! Met Office and NERC 2014.
! However, it has been created with the help of the GungHo Consortium,
! whose members are identified at https://puma.nerc.ac.uk/trac/GungHo/wiki
!-------------------------------------------------------------------------------

!> @brief Provides a partitioning class

!> @details When instantiated, this module partitions the mesh for the
!> supported mesh types: bi-periodic plane and cubed sphere.
!> It provides a list of cells known to this partition. The order of the
!> list is as follows:
!> The cells that are wholly owned by the partition are followed by the cells
!> that might have dofs in the halo and then, the cells that form the
!> the halo. Finally, an extra halo depth of cells is generated, these are
!> called the ghost cells - they are not part of the partitioned domain, but are
!> required to fully describe the cells in the partitioned domain. The first
!> depth of halos are generated by applying a stencil to the owned cells.
!> Subsequent depths of halo are generated by applying the stencil to the
!> previous depth of halo cells

module partition_mod

use constants_mod,   only: i_def, r_def, l_def

implicit none

private

type, public :: partition_type
  private
!> The number of the MPI rank
  integer(i_def)              :: local_rank
!> Total number of MPI ranks in this execution
  integer(i_def)              :: total_ranks
!> A List of global cell ids known to this partition ordered with inner cells
!> first followed by the edge cells and finally the halo cells ordered by
!> depth of halo
  integer(i_def), allocatable :: global_cell_id( : )
!> A list of the ranks that own all the cells known to this partition
!> held in the order of cells in the <code>global_cell_id</code> array
  integer(i_def), allocatable :: cell_owner( : )
!> The number of "inner" cells in the <code>global_cell_id</code> list -
!> one entry for each depth of inner halo
  integer(i_def), allocatable :: num_inner( : )
!> The index of the last "inner" cell in the <code>global_cell_id</code> list -
!> one entry for each depth of inner halo
  integer(i_def), allocatable :: last_inner_cell( : )
!> The depth to which inner halos are generated
  integer(i_def)              :: inner_depth
!> The number of "edge" cells in the <code>global_cell_id</code> list
  integer(i_def)              :: num_edge
!> The index of the last "edge" cell in the <code>global_cell_id</code> list
  integer(i_def)              :: last_edge_cell
!> The number of "halo" cells in the <code>global_cell_id</code> list -
!> one entry for each depth of halo
  integer(i_def), allocatable :: num_halo( : )
!> The index of the last "halo" cell in the <code>global_cell_id</code> list -
!> one entry for each depth of halo
  integer(i_def), allocatable :: last_halo_cell( : )
!> The depth to which halos are generated
  integer(i_def)              :: halo_depth
!> The number of "ghost" cells in the <code>global_cell_id</code> list
  integer(i_def)              :: num_ghost
!> The total number of cells in the global domain
  integer(i_def)              :: global_num_cells

!-------------------------------------------------------------------------------
! Contained functions/subroutines
!-------------------------------------------------------------------------------
contains
  !> @brief  Returns the total of all inner, edge and all halo cells in
  !> a 2d slice on the local partition
  !> @return num_cells The total number of the all inner, edge and
  !>                   halo cells on the local partition
  procedure, public :: get_num_cells_in_layer

  !> @brief Returns the maximum depth of the inner halos
  !> @return inner_depth The maximum depth of the inner halos
  procedure, public :: get_inner_depth

  !> @brief  Gets number of cells in an inner halo 
  !> @details Returns the total number of inner halo cells in a particular
  !>          depth of inner halo in a 2d slice on the local partition
  !> @param[in] depth The depth of the inner halo being queried
  !> @return inner_cells The total number of inner halo cells in the
  !> particular depth on the local partition
  procedure, public :: get_num_cells_inner

  !> @brief  Gets the index of the last cell in an inner halo
  !> @details Returns the index of the last cell in a particular depth
  !>          of inner halo in a 2d slice on the local partition
  !> @param[in] depth The depth of the inner halo being queried
  !> @return last_inner_cell The index of the last cell in the particular depth
  !>         of inner halo on the local partition
  procedure, public :: get_last_inner_cell

  !> @brief  Returns the total number of edge cells in a 2d slice on the local
  !>         partition
  !> @return edge_cells The total number of "edge" cells on the local partition
  procedure, public :: get_num_cells_edge

  !> @brief  Gets the index of the last edge cell in a 2d slice on the local
  !>         partition
  !> @return last_edge_cell The index of the last of "edge" cell on the local
  !>         partition
  procedure, public :: get_last_edge_cell

  !> @brief Returns the maximum depth of the halo
  !> @return halo_depth The maximum depth of halo cells
  procedure, public :: get_halo_depth

  !> @brief  Gets number of cells in a halo 
  !> @details Returns the total number of halo cells in a particular depth
  !>          of halo in a 2d slice on the local partition
  !> @param[in] depth The depth of the halo being queried
  !> @return halo_cells The total number of halo cells of the particular depth
  !> on the local partition
  procedure, public :: get_num_cells_halo

  !> @brief  Gets the index of the last cell in a halo 
  !> @details Returns the index of the last cell in a particular depth
  !>          of halo in a 2d slice on the local partition
  !> @param[in] depth The depth of the halo being queried
  !> @return last_halo_cell The index of the last cell in the particular depth
  !>         of halo on the local partition
  procedure, public :: get_last_halo_cell

  !> @brief Gets the total number of ghost cells in a slice around the local
  !>        partition
  !> @return ghost_cells The total number of ghost cells around the local
  !>         partition
  procedure, public :: get_num_cells_ghost

  !> @brief Returns the local rank number
  !> @return local_rank The number of the local rank
  procedure, public :: get_local_rank

  !> @brief Returns the total number of ranks
  !> @return total_ranks The total number of ranks
  procedure, public :: get_total_ranks

  !> @brief  Returns the owner of a cell on the local partition
  !> @param[in] cell_number The local id of of the cell being queried
  !> @return cell_owner The owner of the given cell
  procedure, public :: get_cell_owner

  !> @brief  Returns the global index of the cell that corresponds to the given
  !!         local index on the local partition
  !> @param[in] lid The id of a cell in local index space
  !> @return gid The id of a cell in global index space
  procedure, public :: get_gid_from_lid

  !> @brief  Returns the local index of the cell on the local
  !> partition that corresponds to the given global index.
  !> @param[in] gid The global index to search for on the local partition
  !> @return lid The local index that corresponds to the given global index
  !>             or -1 if the cell with the given global index is not present
  !>             of the local partition
  procedure, public :: get_lid_from_gid

  !> Overloaded assigment operator
  procedure, public :: partition_type_assign

  !> Routine to destroy partition_type
  !final             :: partition_destructor 

  !> Override default assignment for partition_type pairs.
  generic :: assignment(=) => partition_type_assign

end type partition_type

contains

subroutine partition_type_assign(dest, source)
  class(partition_type), intent(out)   :: dest
  class(partition_type), intent(in)    :: source

  dest%local_rank = source%local_rank
  dest%total_ranks = source%total_ranks
  dest%halo_depth = source%halo_depth

  allocate( dest%num_halo(dest%halo_depth) )
  allocate( dest%last_halo_cell(dest%halo_depth) )
  dest%inner_depth = source%inner_depth
  allocate( dest%num_inner(dest%inner_depth) )
  allocate( dest%last_inner_cell(dest%inner_depth) )
  dest%global_num_cells = source%global_num_cells

  allocate( dest%global_cell_id( size(source%global_cell_id)) )
  dest%global_cell_id=source%global_cell_id
  dest%num_inner=source%num_inner
  dest%num_edge=source%num_edge
  dest%num_halo=source%num_halo
  dest%num_ghost=source%num_ghost

  dest%last_inner_cell=source%last_inner_cell
  dest%last_edge_cell=source%last_edge_cell
  dest%last_halo_cell=source%last_halo_cell

  allocate( dest%cell_owner(size(source%cell_owner)) )
  dest%cell_owner=source%cell_owner

end subroutine partition_type_assign

!-------------------------------------------------------------------------------
! Gets total number of cells in a layer
!-------------------------------------------------------------------------------
function get_num_cells_in_layer( self ) result ( num_cells )
  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def) :: num_cells
  integer(i_def) :: depth   ! loop counter over halo depths

  num_cells = self%num_edge

  do depth = 1,self%inner_depth
    num_cells = num_cells + self%num_inner(depth)
  end do

  do depth = 1,self%halo_depth
    num_cells = num_cells + self%num_halo(depth)
  end do

end function get_num_cells_in_layer

!-------------------------------------------------------------------------------
! Gets the depth of the inner halos that have been set up
!-------------------------------------------------------------------------------
function get_inner_depth( self ) result ( inner_depth )
  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def) :: inner_depth

  inner_depth = self%inner_depth

end function get_inner_depth

!-------------------------------------------------------------------------------
! Gets total number of cells in a particular depth of inner halo in a 2d
! slice on the local partition
!-------------------------------------------------------------------------------
function get_num_cells_inner( self, depth ) result ( inner_cells )
  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def), intent(in) :: depth
  integer(i_def)             :: inner_cells

  if( depth > self%inner_depth )then
    inner_cells = 0
  else
    inner_cells = self%num_inner(depth)
  end if

end function get_num_cells_inner

!-------------------------------------------------------------------------------
! Gets the index of the last cell in a particular depth of inner halo in a 2d
! slice on the local partition
!-------------------------------------------------------------------------------
function get_last_inner_cell( self, depth ) result ( last_inner_cell )
  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def), intent(in) :: depth
  integer(i_def)             :: last_inner_cell

  if( depth > self%inner_depth )then
    last_inner_cell = 0
  else
    last_inner_cell = self%last_inner_cell(depth)
  end if

end function get_last_inner_cell

!-------------------------------------------------------------------------------
! Gets total number of edge cells in a 2d slice on the local partition
!-------------------------------------------------------------------------------
function get_num_cells_edge( self ) result ( edge_cells )
  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def) :: edge_cells

  edge_cells = self%num_edge

end function get_num_cells_edge

!-------------------------------------------------------------------------------
! Gets the index of the last edge cell in a 2d slice on the local partition
!-------------------------------------------------------------------------------
function get_last_edge_cell( self ) result ( last_edge_cell )
  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def) :: last_edge_cell

  last_edge_cell = self%last_edge_cell

end function get_last_edge_cell

!-------------------------------------------------------------------------------
! Gets the depth of the halos that have been set up
!-------------------------------------------------------------------------------
function get_halo_depth( self ) result ( halo_depth )
  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def) :: halo_depth

  halo_depth = self%halo_depth

end function get_halo_depth


!-------------------------------------------------------------------------------
! Gets total number of halo cells in a particular depth of halo in a 2d
! slice on the local partition
!-------------------------------------------------------------------------------
function get_num_cells_halo( self, depth ) result ( halo_cells )
  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def), intent(in) :: depth
  integer(i_def)             :: halo_cells

  if( depth > self%halo_depth )then
    halo_cells = 0
  else
    halo_cells = self%num_halo(depth)
  end if

end function get_num_cells_halo

!-------------------------------------------------------------------------------
! Gets the index of the last halo cell in a particular depth of halo in a 2d
! slice on the local partition
!-------------------------------------------------------------------------------
function get_last_halo_cell( self, depth ) result ( last_halo_cell )
  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def), intent(in) :: depth
  integer(i_def)             :: last_halo_cell

  if( depth > self%halo_depth )then
    last_halo_cell = 0
  else
    last_halo_cell = self%last_halo_cell(depth)
  end if

end function get_last_halo_cell

!-------------------------------------------------------------------------------
! Gets total number of ghost cells in a 2d slice on the local partition
!-------------------------------------------------------------------------------
function get_num_cells_ghost( self ) result ( ghost_cells )
  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def) :: ghost_cells

  ghost_cells = self%num_ghost

end function get_num_cells_ghost


!-------------------------------------------------------------------------------
! Gets the local rank number
!-------------------------------------------------------------------------------
function get_local_rank( self ) result ( local_rank )
  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def) :: local_rank

  local_rank = self%local_rank

end function get_local_rank


!-------------------------------------------------------------------------------
! Gets the total number of ranks being used
!-------------------------------------------------------------------------------
function get_total_ranks( self ) result ( total_ranks )
  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def) :: total_ranks

  total_ranks = self%total_ranks

end function get_total_ranks

!-------------------------------------------------------------------------------
! Gets the owner of a cell on the local partition
!-------------------------------------------------------------------------------
function get_cell_owner( self, cell_number ) result ( cell_owner )

  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def), intent(in) :: cell_number

  integer(i_def) :: cell_owner

  cell_owner=self%cell_owner(cell_number)

end function get_cell_owner

!-------------------------------------------------------------------------------
! Gets the global index of the cell that corresponds to the given
! local index on the local partition
!-------------------------------------------------------------------------------
function get_gid_from_lid( self, lid ) result ( gid )

  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def), intent(in) :: lid           ! local index
  integer(i_def)             :: gid           ! global index
  integer(i_def)             :: nlayer        ! layer of supplied lid
  integer(i_def)             :: lid_in_layer  ! supplied lid projected to bottom layer
  integer(i_def)             :: num_in_list   ! total number of cells in partition
  integer(i_def)             :: depth         ! loop counter over halo depths

  num_in_list = self%num_edge + self%num_ghost
  do depth = 1,self%inner_depth
    num_in_list = num_in_list + self%num_inner(depth)
  end do
  do depth = 1,self%halo_depth
    num_in_list = num_in_list + self%num_halo(depth)
  end do
  lid_in_layer = modulo(lid-1,(num_in_list))+1
  nlayer = (lid-1)/(num_in_list)

  gid = self%global_cell_id(lid_in_layer) + nlayer*(self%global_num_cells)

end function get_gid_from_lid

!-------------------------------------------------------------------------------
! Gets the local index of the cell on the local partition that corresponds
! to the given global index
!-------------------------------------------------------------------------------
function get_lid_from_gid( self, gid ) result ( lid )
!
! Performs a search through the global cell lookup table looking for the
! required global index.
!
! The partitioned_cells array holds global indices in various groups:
! the inner halos, then the edge cells, the halo cells and finally
! the ghost cells. The cells are numerically ordered within the different
! groups so a binary search can be used, but not between groups, so need to do
! separate binary searches through the inner, edge, halo and ghost cells and
! exit if a match is found
!
  implicit none

  class(partition_type), intent(in) :: self

  integer(i_def), intent(in) :: gid           ! global index
  integer(i_def)             :: lid           ! local index
  integer(i_def)             :: nlayer        ! layer of supplied gid
  integer(i_def)             :: gid_in_layer  ! supplied gid projected to bottom layer
  integer(i_def)             :: depth         ! loop counter over halo depths
  integer(i_def)             :: start_search  ! start point for a search
  integer(i_def)             :: end_search    ! end point for a search
  integer(i_def)             :: num_in_list   ! total number of cells in partition
  integer(i_def)             :: num_halo      ! number of halo points already counted
  integer(i_def)             :: num_inner! number of inner halo points already counted

  num_in_list = self%num_edge
  do depth = 1,self%inner_depth
    num_in_list = num_in_list + self%num_inner(depth)
  end do
  do depth = 1,self%halo_depth
    num_in_list = num_in_list + self%num_halo(depth)
  end do

  ! Set the default return code
  lid = -1
  ! If the supplied gid is not valid just return
  if(gid < 1) return

  ! The global index lookup table (partitioned_cells) only has the indices for
  ! a single layer, so convert the full 3d global index into the global index
  ! within the layer and a layer number
  gid_in_layer = modulo(gid-1,self%global_num_cells) + 1
  nlayer = (gid-1) / self%global_num_cells

  ! Search though the inner halo cells - looking for the gid
  end_search = 0
  num_inner=0
  do depth = self%inner_depth, 1, -1
    start_search = end_search + 1
    end_search = start_search + self%num_inner(depth) - 1
    lid = binary_search( self%global_cell_id( start_search:end_search ), gid )
    if(lid /= -1)then
      lid = lid +  num_inner + nlayer*(num_in_list)  !convert back to 3d lid
      return
    end if
    num_inner = num_inner + self%num_inner(depth)
  end do

  ! Search though edge cells - looking for the gid
  start_search = end_search + 1
  end_search = start_search + self%num_edge - 1
  lid = binary_search( self%global_cell_id( start_search:end_search ), gid )
  if(lid /= -1)then
    lid = lid + num_inner + nlayer*(num_in_list)  !convert back to 3d lid
    return
  end if

  ! Search though halo and ghost cells - looking for the gid
  num_halo=0
  do depth = 1,self%halo_depth +1
    start_search = end_search + 1
    if(depth <= self%halo_depth) then
      end_search = start_search + self%num_halo(depth) - 1
    else
      end_search = start_search + self%num_ghost - 1
    end if
    lid = binary_search( self%global_cell_id( start_search:end_search ), gid )
    if(lid /= -1)then
      lid = lid + num_inner + self%num_edge + num_halo + &
                                   nlayer*(num_in_list)  !convert back to 3d lid
      return
    end if
    if(depth <= self%halo_depth) then
      num_halo = num_halo + self%num_halo(depth)
    end if
  end do

  ! No lid has been found in either the inner, edge or halo cells on this
  ! partition, so return with lid=-1
  return

end function get_lid_from_gid

!-------------------------------------------------------------------------------
! Performs a binary search through the given array. PRIVATE function.
!-------------------------------------------------------------------------------
! Details: Performs a binary search through the given array looking for a
!          particular entry and returns the index of the entry found or -1 if no
!          matching entry can be found. The values held in "array_to_be_searched"
!          must be in numerically increasing order.
! Input:   array_to_be_searched  The array that will be searched for the given entry
!          value_to_find         The entry that is to be searched for
!-------------------------------------------------------------------------------
pure function binary_search( array_to_be_searched, value_to_find ) result ( id )

  implicit none

  integer(i_def), intent(in) :: array_to_be_searched( : )
  integer(i_def), intent(in) :: value_to_find
  integer(i_def)             :: bot, top  ! Lower and upper index limits between which to search for the value
  integer(i_def)             :: id        ! Next index for refining the search. If an entry is found this will
                                   ! contain the index of the matching entry

  ! Set bot and top to be the whole array to begin with
  bot = 1
  top = size(array_to_be_searched)

  search: do
    ! If top is lower than bot then there is no more array to be searched
    if(top < bot) exit search
    ! Refine the search
    id = (bot+top)/2
    if(array_to_be_searched(id) == value_to_find)then  ! found matching entry
      return
    else if(array_to_be_searched(id) < value_to_find)then ! entry has to be between id and top
      bot = id + 1
    else ! entry has to be between bot and id
      top = id - 1
    endif
  end do search

  ! Didn't find a match - return failure code
  id = -1

end function binary_search

!-------------------------------------------------------------------------------
! Performs a simple bubble sort on an array. PRIVATE function.
!-------------------------------------------------------------------------------
! Details: Performs a bubble sort on an array of data.
! Input:   array  The array that will be sorted
!          len  The length of the array to be sorted
!-------------------------------------------------------------------------------
subroutine bubble_sort(array, len)
integer(i_def), intent(inout) :: array(:)
integer(i_def), intent(in)    :: len

logical(l_def) :: swapped
integer(i_def) :: i
integer(i_def) :: swap_temp

do
  swapped = .false.
  do i = 1,len-1
    if(array(i) > array(i+1))then
      swap_temp = array(i)
      array(i) = array(i+1)
      array(i+1) = swap_temp
      swapped = .true.
    end if
  end do
  if( .not.swapped )exit
end do

end subroutine bubble_sort

!==============================================================================
! The following routines are only available when setting data for unit testing.
!==============================================================================
!> @brief   Stucture-Constructor (for unit testing)
!> @returns A partition object based on a 9-cell global mesh (3x3) with one
!>          partition and quadralateral reference cells
!============================================================================
function partition_constructor_unit_test_data() result (self)

  implicit none

  type(partition_type) :: self

  ! Returns partition object from global_mesh of size 3x3 quad reference cell
  ! (see global_mesh_mod for data) which only has one partition.

  self%local_rank        = 0
  self%total_ranks       = 1
  self%halo_depth        = 1
  self%inner_depth       = 1
  self%global_num_cells  = 9

  allocate( self%global_cell_id (self%global_num_cells) )
  allocate( self%cell_owner     (self%global_num_cells) )
  allocate( self%num_inner      (self%inner_depth) )
  allocate( self%last_inner_cell(self%inner_depth) )
  allocate( self%num_halo       (self%halo_depth) )
  allocate( self%last_halo_cell (self%halo_depth) )

  self%global_cell_id    = [1,2,3,4,5,6,7,8,9]
  self%cell_owner        = [0,0,0,0,0,0,0,0,0]
  self%num_inner(1)      = 9
  self%last_inner_cell(1)= 9
  self%num_edge          = 0
  self%last_edge_cell    = 9
  self%num_halo(1)       = 0
  self%last_halo_cell(1) = 9
  self%num_ghost         = 0

end function partition_constructor_unit_test_data

end module partition_mod
