#lang scribble/doc
@(require "common.rkt"
          (for-label racket/draw/draw-unit racket/draw/draw-sig))

@;{@title{Signature and Unit}}
@title[#:tag "signature-and-unit"]{签名和单元}

@;{The @racketmodname[racket/draw/draw-sig] and
@racketmodname[racket/draw/draw-unit] libraries define the
@racket[draw^] signature and @racket[draw@] implementation.}
@racketmodname[racket/draw/draw-sig]和@racketmodname[racket/draw/draw-unit]库定义@racket[draw^]签名和@racket[draw@]实现。

@;{@section{Draw Unit}}
@section{绘图单元}

@defmodule[racket/draw/draw-unit]

@defthing[draw@ unit?]{
@;{Re-exports all of the exports of @racketmodname[racket/draw].}
重新导出@racketmodname[racket/draw]的所有导出。
}


@;{@section{Draw Signature}}
@section{绘图签名}

@defmodule[racket/draw/draw-sig]

@defsignature[draw^ ()]

@;{Includes all of the identifiers exported by @racketmodname[racket/draw].}
包括通过@racketmodname[racket/draw]导出的所有标识符。
