#lang scribble/manual

@(require "common.rkt" (for-label racket/draw/arrow))

@;{@title{Drawing Conveniences}}
@title[#:tag "drawing-conveniences"]{绘图便利}

@;{This section presents higher-level APIs that provide additional conveniences
over the @racket[racket/draw] API.}
本节介绍更高级别的API，这些API为@racket[racket/draw]的API提供了额外的便利。

@;{@section{Arrows}}
@section{箭头}
@defmodule[racket/draw/arrow]

@defproc[(draw-arrow [dc (is-a?/c dc<%>)]
                     [start-x real?]
                     [start-y real?]
                     [end-x real?]
                     [end-y real?]
                     [dx real?]
                     [dy real?]
                     [#:pen-width pen-width (or/c real? #f) #f]
                     [#:arrow-head-size arrow-head-size real? 8]
                     [#:arrow-root-radius arrow-root-radius real? 2.5])
           void?]{
@;{Draws an arrow on @racket[dc] from (@racket[start-x], @racket[start-y]) to
(@racket[end-x], @racket[end-y]). (@racket[dx], @racket[dy]) is the top-left
location for drawing.}
  在@racket[dc]上从(@racket[start-x], @racket[start-y])到(@racket[end-x], @racket[end-y])绘制箭头。(@racket[dx], @racket[dy])是用于绘图的左上角位置。
  
@;{If @racket[pen-width] is @racket[#f], the current pen width is used.}
  如果@racket[pen-width]为@racket[#f]，则使用当前的笔宽。

@history[#:added "1.9"]{}
}
