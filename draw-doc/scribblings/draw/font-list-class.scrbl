#lang scribble/doc
@(require "common.rkt")

@defclass/title[font-list% object% ()]{

@;{A @racket[font-list%] object maintains a list of @racket[font%]
 objects to avoid repeatedly creating fonts.}
  @racket[font-list%]对象维护@racket[font%]对象的列表，以避免重复创建字体。

@;{A global font list, @racket[the-font-list], is created automatically.}
 自动创建一个全局字体列表，即@racket[the-font-list]。 


@defconstructor[()]{

@;{Creates an empty font list.}
  创建空字体列表。

}

@defmethod*[([(find-or-create-font [size (real-in 0.0 1024.0)]
                                   [family (or/c 'default 'decorative 'roman 'script 
                                                 'swiss 'modern 'symbol 'system)]
                                   [style (or/c 'normal 'italic 'slant)]
                                   [weight (or/c 'normal 'bold 'light)]
                                   [underline? any/c #f]
                                   [smoothing (or/c 'default 'partly-smoothed 'smoothed 'unsmoothed) 'default]
                                   [size-in-pixels? any/c #f]
                                   [hinting (or/c 'aligned 'unaligned) 'aligned])
              (is-a?/c font%)]
             [(find-or-create-font [size (real-in 0.0 1024.0)]
                                   [face string?]
                                   [family (or/c 'default 'decorative 'roman 'script
                                                 'swiss 'modern 'symbol 'system)]
                                   [style (or/c 'normal 'italic 'slant)]
                                   [weight (or/c 'normal 'bold 'light)]
                                   [underline any/c #f]
                                   [smoothing (or/c 'default 'partly-smoothed 'smoothed 'unsmoothed) 'default]
                                   [size-in-pixels? any/c #f]
                                   [hinting (or/c 'aligned 'unaligned) 'aligned])
              (is-a?/c font%)])]{

@;{Finds an existing font in the list or creates a new one (that is
 automatically added to the list). The arguments are the same as for
 creating a @racket[font%] instance.}
在列表中查找现有字体或创建新字体（自动添加到列表中）。参数与创建@racket[font%]实例的参数相同。

@history[#:changed "1.4" @elem{@;{@;{Changed @racket[size] to allow non-integer and zero values.}更改了@racket[size]以允许非整数和零值。}}]}}
