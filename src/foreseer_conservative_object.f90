!< Define the abstract conservative state of a Riemann Problem for FORESEER library.

module foreseer_conservative_object
!< Define the abstract conservative state of a Riemann Problem for FORESEER library.

use foreseer_eos_object, only : eos_object
use penf, only : R8P
use vecfor, only : vector

implicit none
private
public :: conservative_object

type, abstract :: conservative_object
   !< Convervative object class.
   contains
      ! deferred methods
      procedure(array_interface),          pass(self), deferred :: array              !< Return serialized array of conservative.
      procedure(compute_fluxes_interface), pass(self), deferred :: compute_fluxes     !< Compute conservative fluxes.
      procedure(description_interface),    pass(self), deferred :: description        !< Return pretty-printed object description.
      procedure(destroy_interface),        pass(self), deferred :: destroy            !< Destroy conservative.
      procedure(initialize_interface),     pass(self), deferred :: initialize         !< Initialize conservative.
      procedure(pressure_interface),       pass(self), deferred :: pressure           !< Return pressure value.
      procedure(velocity_interface),       pass(self), deferred :: velocity           !< Return velocity vector.
      procedure(assignment_interface),     pass(lhs),  deferred :: cons_assign_cons   !< Operator `=`.
      procedure(cons_operator_real),       pass(lhs),  deferred :: cons_divide_real   !< Operator `cons / real`.
      procedure(symmetric_operator),       pass(lhs),  deferred :: cons_multiply_cons !< Operator `*`.
      procedure(cons_operator_real),       pass(lhs),  deferred :: cons_multiply_real !< Operator `cons * real`.
      procedure(real_operator_cons),       pass(rhs),  deferred :: real_multiply_cons !< Operator `real * cons`.
      procedure(symmetric_operator),       pass(lhs),  deferred :: add                !< Operator `+`.
      procedure(unary_operator),           pass(self), deferred :: positive           !< Unary operator `+ cons`.
      procedure(symmetric_operator),       pass(lhs),  deferred :: sub                !< Operator `-`.
      procedure(unary_operator),           pass(self), deferred :: negative           !< Unary operator `- cons`.
      ! operators
      generic :: assignment(=) => cons_assign_cons                                         !< Overload `=`.
      generic :: operator(+) => add, positive                                              !< Overload `+`.
      generic :: operator(-) => sub, negative                                              !< Overload `-`.
      generic :: operator(*) => cons_multiply_cons, cons_multiply_real, real_multiply_cons !< Overload `*`.
      generic :: operator(/) => cons_divide_real                                           !< Overload `/`.
endtype conservative_object

abstract interface
   !< Abstract interfaces of deferred methods of [[conservative_object]].
   pure function array_interface(self) result(array_)
   !< Return serialized array of conservative.
   import :: conservative_object, R8P
   class(conservative_object), intent(in) :: self      !< Conservative.
   real(R8P), allocatable                 :: array_(:) !< Serialized array of conservative.
   endfunction array_interface

   subroutine compute_fluxes_interface(self, eos, normal, fluxes)
   !< Compute conservative fluxes.
   import :: conservative_object, eos_object, vector
   class(conservative_object), intent(in)  :: self   !< Conservative.
   class(eos_object),          intent(in)  :: eos    !< Equation of state.
   type(vector),               intent(in)  :: normal !< Normal (versor) of face where fluxes are given.
   class(conservative_object), intent(out) :: fluxes !< Conservative fluxes.
   endsubroutine compute_fluxes_interface

   pure function description_interface(self, prefix) result(desc)
   !< Return a pretty-formatted object description.
   import :: conservative_object
   class(conservative_object), intent(in)           :: self   !< Conservative.
   character(*),               intent(in), optional :: prefix !< Prefixing string.
   character(len=:), allocatable                    :: desc   !< Description.
   endfunction description_interface

   elemental subroutine destroy_interface(self)
   !< Destroy conservative.
   import :: conservative_object
   class(conservative_object), intent(inout) :: self !< Conservative.
   endsubroutine destroy_interface

   subroutine initialize_interface(self, initial_state)
   !< Initialize conservative.
   import :: conservative_object
   class(conservative_object),           intent(inout) :: self          !< Conservative.
   class(conservative_object), optional, intent(in)    :: initial_state !< Initial state.
   endsubroutine initialize_interface

   elemental function pressure_interface(self, eos) result(pressure_)
   !< Return pressure value.
   import :: conservative_object, eos_object, R8P
   class(conservative_object), intent(in) :: self      !< Conservative.
   class(eos_object),          intent(in) :: eos       !< Equation of state.
   real(R8P)                              :: pressure_ !< Pressure value.
   endfunction pressure_interface

   elemental function velocity_interface(self) result(velocity_)
   !< Return velocity vector.
   import :: conservative_object, vector
   class(conservative_object), intent(in) :: self      !< Conservative.
   type(vector)                           :: velocity_ !< Velocity vector.
   endfunction velocity_interface

   pure subroutine assignment_interface(lhs, rhs)
   !< Operator `=`.
   import :: conservative_object
   class(conservative_object), intent(inout) :: lhs !< Left hand side.
   class(conservative_object), intent(in)    :: rhs !< Right hand side.
   endsubroutine assignment_interface

   function cons_operator_real(lhs, rhs) result(operator_result)
   !< Operator `cons.op.real`.
   import :: conservative_object, R8P
   class(conservative_object), intent(in)  :: lhs             !< Left hand side.
   real(R8P),                  intent(in)  :: rhs             !< Right hand side.
   class(conservative_object), allocatable :: operator_result !< Operator result.
   endfunction cons_operator_real

   function real_operator_cons(lhs, rhs) result(operator_result)
   !< Operator `real.op.cons`.
   import :: conservative_object, R8P
   real(R8P),                  intent(in)  :: lhs             !< Left hand side.
   class(conservative_object), intent(in)  :: rhs             !< Right hand side.
   class(conservative_object), allocatable :: operator_result !< Operator result.
   endfunction real_operator_cons

   function symmetric_operator(lhs, rhs) result(operator_result)
   !< Symmetric operator `cons.op.cons`.
   import :: conservative_object
   class(conservative_object), intent(in)  :: lhs             !< Left hand side.
   class(conservative_object), intent(in)  :: rhs             !< Right hand side.
   class(conservative_object), allocatable :: operator_result !< Operator result.
   endfunction symmetric_operator

   function unary_operator(self) result(operator_result)
   !< Unary operator `.op.cons`.
   import :: conservative_object
   class(conservative_object), intent(in)  :: self            !< Conservative.
   class(conservative_object), allocatable :: operator_result !< Operator result.
   endfunction unary_operator
endinterface
endmodule foreseer_conservative_object