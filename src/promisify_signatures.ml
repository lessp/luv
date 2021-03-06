(* This file is part of Luv, released under the MIT license. See LICENSE.md for
   details, or visit https://github.com/aantron/luv/blob/master/LICENSE.md. *)



module type PROMISE =
sig
  type 'a promise
  val make : unit -> 'a promise * ('a -> unit)
end

module type PROMISIFIED =
sig
  type 'a promise

  module Timer :
  sig
    val delay :
      ?loop:Loop.t ->
      ?call_update_time:bool ->
      int ->
        ((unit, Error.t) Result.result) promise
  end

  module Stream :
  sig
    open Stream

    val shutdown :
      _ t ->
        ((unit, Error.t) Result.result) promise

    val read :
      ?allocate:(int -> Bigstring.t) ->
      _ t ->
        (Bigstring.t, Error.t) Result.result promise

    val write :
      ?send_handle:[< `TCP | `Pipe ] t ->
      _ t ->
      Bigstring.t list ->
        ((unit, Error.t) Result.result * int) promise
  end

  module TCP :
  sig
    val connect :
      TCP.t ->
      Misc.Sockaddr.t ->
        ((unit, Error.t) Result.result) promise
  end

  module File :
  sig
    open File

    val open_ :
      ?loop:Loop.t ->
      ?request:Request.t ->
      ?mode:Mode.t ->
      string ->
      Open_flag.t ->
        ((t, Error.t) Result.result) promise

    val close :
      ?loop:Loop.t ->
      ?request:Request.t ->
      t ->
        ((unit, Error.t) Result.result) promise

    val read :
      ?loop:Loop.t ->
      ?request:Request.t ->
      ?offset:int64 ->
      t ->
      Bigstring.t list ->
        ((Unsigned.Size_t.t, Error.t) Result.result) promise
  end

  module DNS :
  sig
    open DNS

    val getaddrinfo :
      ?loop:Loop.t ->
      ?request:Addr_info.Request.t ->
      ?family:Misc.Address_family.t ->
      ?socktype:Misc.Socket_type.t ->
      ?protocol:int ->
      ?flags:Addr_info.Flag.t ->
      ?node:string ->
      ?service:string ->
      unit ->
        ((Addr_info.t list, Error.t) Result.result) promise

    val getnameinfo :
      ?loop:Loop.t ->
      ?request:Name_info.Request.t ->
      ?flags:Name_info.Flag.t ->
      Misc.Sockaddr.t ->
        ((string * string, Error.t) Result.result) promise
  end
end
