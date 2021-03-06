(* This file is part of Luv, released under the MIT license. See LICENSE.md for
   details, or visit https://github.com/aantron/luv/blob/master/LICENSE.md. *)



type t = C.Types.Loop.t Ctypes.ptr

val init : unit -> (t, Error.t) Result.result

module Option :
sig
  type 'value t
  val block_signal : int t
  val sigprof : int
end

val configure : t -> 'value Option.t -> 'value -> (unit, Error.t) Result.result

val close : t -> (unit, Error.t) Result.result
val default : unit -> t

module Run_mode :
sig
  type t
  val default : t
  val once : t
  val nowait : t
end

val run : ?loop:t -> ?mode:Run_mode.t -> unit -> bool
val alive : t -> bool
val stop : t -> unit
val size : unit -> Unsigned.size_t
val backend_fd : t -> int
val backend_timeout : t -> int
val now : t -> Unsigned.UInt64.t
val update_time : t -> unit

val fork : t -> (unit, Error.t) Result.result

val get_data : t -> unit Ctypes.ptr
val set_data : t -> unit Ctypes.ptr -> unit

(**/**)

val or_default : t option -> t
