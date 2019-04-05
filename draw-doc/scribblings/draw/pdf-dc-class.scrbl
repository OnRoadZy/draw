#lang scribble/doc
@(require "common.rkt")

@defclass/title[pdf-dc% object% (dc<%>)]{

@;{Like @racket[post-script-dc%], but generates a PDF file instead of a
 PostScript file.}
  与@racket[post-script-dc%]类似，但生成的是PDF文件而不是PostScript文件。

@defconstructor[([interactive any/c #t]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                 [use-paper-bbox any/c #f]
                 [as-eps any/c #t]
                 [width (or/c (and/c real? (not/c negative?)) #f) #f]
                 [height (or/c (and/c real? (not/c negative?)) #f) #f]
                 [output (or/c path-string? output-port? #f) #f])]{

@;{See @racket[post-script-dc%] for information on the arguments. The
@racket[as-eps] argument is allowed for consistency with
@racket[post-script-dc%], but its value is ignored.}}
有关参数的信息，请参阅@racket[post-script-dc%]。@racket[as-eps]参数允许与@racket[post-script-dc%]保持一致，但其值被忽略。
}
