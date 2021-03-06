(* This file is part of Luv, released under the MIT license. See LICENSE.md for
   details, or visit https://github.com/aantron/luv/blob/master/LICENSE.md. *)



type t = [ `TCP ] Stream.t

module Bind_flag :
sig
  type t
  val ipv6only : t
end

val init :
  ?loop:Loop.t -> ?domain:Misc.Address_family.t -> unit ->
    (t, Error.t) Result.result
val open_ : t -> Misc.Os_socket.t -> (unit, Error.t) Result.result
val nodelay : t -> bool -> (unit, Error.t) Result.result
val keepalive : t -> int option -> (unit, Error.t) Result.result
val simultaneous_accepts : t -> bool -> (unit, Error.t) Result.result
val bind :
  ?flags:Bind_flag.t -> t -> Misc.Sockaddr.t -> (unit, Error.t) Result.result
(* DOC the family must be one of the INET families. *)
val getsockname : t -> (Misc.Sockaddr.t, Error.t) Result.result
val getpeername : t -> (Misc.Sockaddr.t, Error.t) Result.result
val connect :
  t -> Misc.Sockaddr.t -> ((unit, Error.t) Result.result -> unit) -> unit
val close_reset : t -> ((unit, Error.t) Result.result -> unit) -> unit
