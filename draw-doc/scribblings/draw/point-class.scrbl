#lang scribble/doc
@(require "common.rkt")

@defclass/title[point% object% ()]{

@;{A @racket[point%] is used for certain drawing commands. It
 encapsulates two real numbers.}
  @racket[point%]用于某些绘图命令。它封装了两个实数。

@defconstructor*/make[(()
                       ([x real?]
                        [y real?]))]{

@;{Creates a point. If @racket[x] and @racket[y] are not supplied, they
 are set to @racket[0].}
  创建一个点。如果未提供@racket[x]和Y，则将其设置为@racket[y]。
}

@defmethod[(get-x)
           real?]{
@;{Gets the point x-value.}
  获取点x值。

}

@defmethod[(get-y)
           real?]{
@;{Gets the point y-value.}
  获取点y值。

}

@defmethod[(set-x [x real?])
           void?]{
@;{Sets the point x-value.}
  设置点x值。

}

@defmethod[(set-y [y real?])
           void?]{

@;{Sets the point y-value.}
  设置点y值。

}}

