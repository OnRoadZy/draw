#lang scribble/doc
@(require "common.rkt")

@;{@title{Drawing Functions}}
@title[#:tag "drawing-functions"]{Drawing Functions}

@local-table-of-contents[]

@defparam[current-ps-setup pss (is-a?/c ps-setup%)]{

@;{A parameter that determines the current PostScript configuration
 settings. See @racket[post-script-dc%] and @racket[printer-dc%].}
确定当前PostScript配置设置的参数。请参阅@racket[post-script-dc%]和@racket[printer-dc%]。
}


@defproc[(get-face-list [kind (or/c 'mono 'all) 'all]
                        [#:all-variants? all-variants? any/c #f])
         (listof string?)]{

@;{Returns a list of font face names available on the current system.  If
 @racket[kind] is @racket['mono], then only faces that are known to
 correspond to monospace fonts are included in the list.}
  返回当前系统上可用的字体名称列表。如果 @racket[kind]是@racket['mono]，那么列表中只包含已知与monospace字体对应的面。

@;{If @racket[all-variants?] is @racket[#f] (the default), then the
 result is in more standard terminology a list of font
 family names, which are combined with style and weight options to
 arrive at a face; if @racket[all-variants?] is true, then the result
 includes a string for each available face in the family.}
  如果@racket[all-variants?]是@racket[#f]（默认值），那么结果是在更标准的术语中是字体系列名称列表，它与样式和权重选项组合在一起以到达一个表面；如果@racket[all-variants?]为真，则结果包括族中每个可用表面的字符串。
  }


@defproc[(get-family-builtin-face [family (or/c 'default 'decorative 'roman 'script 
                                                'swiss 'modern 'symbol 'system)])
         string?]{

@;{Returns the built-in default face mapping for a particular font
 family.}
返回特定字体系列的内置默认表面映射。

@;{See @racket[font%] for information about @racket[family].}
  有关系列的信息，请参见@racket[font%]。
}


@defproc[(make-bitmap [width exact-positive-integer?]
                      [height exact-positive-integer?]
                      [alpha? any/c #t]
                      [#:backing-scale backing-scale (>/c 0.0) 1.0])
         (is-a?/c bitmap%)]{

@;{Returns @racket[(make-object bitmap% width height #f alpha?
backing-scale)], but this procedure is preferred because it defaults
@racket[alpha?] in a more useful way.}
返回@racket[(make-object bitmap% width height #f alpha?
backing-scale)]，但是这个过程是首选的，因为它默认@racket[alpha?]以一种更有用的方式。

@;{See also @racket[make-platform-bitmap] and @secref["Portability"].}
另请参见@racket[make-platform-bitmap]和@secref["Portability"]。
  
@history[#:changed "1.1" @elem{@;{Added the @racket[#:backing-scale]
optional argument.}添加了@racket[#:backing-scale]可选参数。}]
}


@defproc[(make-brush
          [#:color color (or/c string? (is-a?/c color%))  (make-color 0 0 0)]
          [#:style style (or/c 'transparent 'solid 'opaque
                               'xor 'hilite 'panel
                               'bdiagonal-hatch 'crossdiag-hatch
                               'fdiagonal-hatch 'cross-hatch
                               'horizontal-hatch 'vertical-hatch)
                   'solid]
          [#:stipple stipple (or/c #f (is-a?/c bitmap%))
                     #f]
          [#:gradient gradient (or/c #f
                                    (is-a?/c linear-gradient%)
                                    (is-a?/c radial-gradient%))
                      #f]
          [#:transformation
           transformation (or/c #f (vector/c (vector/c real? real? real?
                                                       real? real? real?)
                                              real? real? real? real? real?))
                          #f]
          [#:immutable? immutable? any/c #t])
         (is-a?/c brush%)]{

@;{Creates a @racket[brush%] instance. This procedure provides a
nearly equivalent interface compared to using
@racket[make-object] with @racket[brush%], but it also supports
the creation of immutable brushes (and creates immutable burshes by default).}
  创建@racket[brush%]实例。与使用使用@racket[brush%]的@racket[make-object]相比，此过程提供了几乎等效的接口，但它还支持创建不可变的画笔（并在默认情况下创建不可变的画笔）。

@;{When @racket[stipple] is @racket[#f], @racket[gradient] is
@racket[#f], @racket[transformation] is @racket[#f],
@racket[immutable?] is true, and @racket[color] is either a
@racket[color%] object or a string in @racket[the-color-database], the
result brush is created via @method[brush-list% find-or-create-brush] of
@racket[the-brush-list].}
  当@racket[stipple]为@racket[#f]时，@racket[gradient]为@racket[#f]，@racket[transformation]为@racket[#f]，@racket[immutable?]为真，并且@racket[color]是@racket[color%]对象或@racket[the-color-database]中的字符串，结果画笔是通过@racket[the-brush-list]的@method[brush-list% find-or-create-brush]创建的。
  }

@;{A brush transformation has the same representation and meaning as for
 @xmethod[dc<%> get-transformation].}
刷子转换与@xmethod[dc<%> get-transformation]具有相同的表示和含义。

@defproc[(make-color [red byte?] [green byte?] [blue byte?]
                     [alpha (real-in 0 1) 1.0])
         (is-a?/c color%)]{

@;{Creates a @racket[color%] instance. This procedure provides a
nearly equivalent interface compared to using
@racket[make-object] with @racket[color%], but it creates
an immutable @racket[color%] object.}
  创建@racket[color%]实例。此过程提供了一个与使用使用@racket[color%]的@racket[make-object]几乎等效的接口，但它创建了一个不可变的@racket[color%]对象。

@;{To create an immutable color based on a color string, use @method[color-database<%> find-color]
or @racket[the-color-database].}
  要基于颜色字符串创建不可变的颜色，请使用@method[color-database<%> find-color]或@racket[the-color-database]。
  }


@defproc[(make-font [#:size size (real-in 0.0 1024.0) 12]
                    [#:face face (or/c string? #f) #f]
                    [#:family family (or/c 'default 'decorative 'roman 'script 
                                           'swiss 'modern 'symbol 'system)
                              'default]
                    [#:style style (or/c 'normal 'italic 'slant) 'normal]
                    [#:weight weight font-weight/c 'normal]
                    [#:underlined? underlined? any/c #f]
                    [#:smoothing smoothing (or/c 'default 'partly-smoothed 
                                                 'smoothed 'unsmoothed) 
                                 'default]
                    [#:size-in-pixels? size-in-pixels? any/c #f]
                    [#:hinting hinting (or/c 'aligned 'unaligned) 'aligned])
         (is-a?/c font%)]{

@;{Creates a @racket[font%] instance. This procedure provides an
equivalent but more convenient interface compared to using
@racket[make-object] with @racket[font%].}
  创建@racket[font%]实例。与使用@racket[font%]的@racket[make-object]相比，此过程提供了一个等效但更方便的接口。

@history[#:changed "1.4" @elem{@;{Changed @racket[size] to allow non-integer and zero values.}已更改@racket[size]以允许非整数和零值。}
         #:changed "1.14" @elem{@;{Changed @racket[weight] to allow integer values and the symbols
                                @racket['thin], @racket['ultralight], @racket['semilight],
                                @racket['book], @racket['medium], @racket['semibold],
                                @racket['ultrabold], @racket['heavy], and @racket['ultraheavy].}更改@racket[weight]以允许整数值和符号@racket['thin]、 @racket['ultralight]、@racket['semilight]、@racket['book]、@racket['medium]、 @racket['semibold]、@racket['ultrabold]、@racket['heavy]和@racket['ultraheavy]。}]}


@defproc[(make-monochrome-bitmap [width exact-positive-integer?]
                                 [height exact-positive-integer?]
                                 [bits (or/c bytes? #f) #f])
         (is-a?/c bitmap%)]{

@;{Returns @racket[(make-object bitmap% width height #t)] if
@racket[bits] is @racket[#f], or @racket[(make-object bitmap% bits
width height)] otherwise. This procedure is preferred to using
@racket[make-object] on @racket[bitmap%] because it is less
overloaded.}
  如果@racket[bits]为@racket[#f]，则返回@racket[(make-object bitmap% width height #t)]，否则返回@racket[(make-object bitmap% bits
width height)]。此过程优先于在@racket[bitmap%]上使用@racket[make-object]，因为它的重载程度较低。
  }

@defproc[(make-pen
          [#:color color (or/c string? (is-a?/c color%)) (make-color 0 0 0)]
          [#:width width (real-in 0 255) 0]
          [#:style style (or/c 'transparent 'solid 'xor 'hilite
                               'dot 'long-dash 'short-dash 'dot-dash
                               'xor-dot 'xor-long-dash 'xor-short-dash
                               'xor-dot-dash)
                   'solid]
          [#:cap cap (or/c 'round 'projecting 'butt)
                     'round]
          [#:join join (or/c 'round 'bevel 'miter)
                  'round]
          [#:stipple stipple (or/c #f (is-a?/c bitmap%))
                     #f]
          [#:immutable? immutable? any/c #t])
         (is-a?/c pen%)]{

@;{Creates a @racket[pen%] instance. This procedure provides a
nearly equivalent interface compared to using
@racket[make-object] with @racket[pen%], but it also supports
the creation of immutable pens (and creates immutable pens by default).}
  创建@racket[pen%]实例。与使用@racket[pen%]的@racket[make-object]相比，此过程提供了几乎等效的接口，但它还支持创建不可变的笔（默认情况下创建不可变的笔）。

@;{When @racket[stipple] is @racket[#f], @racket[immutable?] is true, and
@racket[color] is either a @racket[color%] object or a string in
@racket[the-color-database], the result pen is created via
@method[pen-list% find-or-create-pen] of @racket[the-pen-list].}
@racket[stipple]是@racket[#f]时，@racket[immutable?]为真，并且@racket[color]是@racket[color%]对象或@racket[the-color-database]中的字符串，结果笔是通过@racket[the-pen-list]的@method[pen-list% find-or-create-pen]创建的。
}


@defproc[(make-platform-bitmap [width exact-positive-integer?]
                               [height exact-positive-integer?]
                               [#:backing-scale backing-scale (>/c 0.0) 1.0])
         (is-a?/c bitmap%)]{

@;{Creates a bitmap that uses platform-specific drawing operations
as much as possible, which is different than a @racket[make-bitmap] result
on Windows and Mac OS. See @secref["Portability"] for more information.}
  创建尽可能多地使用平台特定绘图操作的位图，这与Windows和Mac OS上的@racket[make-bitmap]结果不同。有关更多信息，请参见@secref["Portability"]。

@history[#:changed "1.1" @elem{@;{Added the @racket[#:backing-scale]
optional argument.}添加@racket[#:backing-scale]可选参数。}]}
                 

@defproc[(read-bitmap [in (or path-string? input-port?)]
                      [kind (or/c 'unknown 'unknown/mask 'unknown/alpha
                                  'gif 'gif/mask 'gif/alpha 
                                  'jpeg 'jpeg/alpha
                                  'png 'png/mask 'png/alpha
                                  'xbm 'xbm/alpha 'xpm 'xpm/alpha
                                  'bmp 'bmp/alpha)
                            'unknown/alpha]
                      [bg-color (or/c (is-a?/c color%) #f) #f]
                      [complain-on-failure? any/c #t]
                      [#:backing-scale backing-scale (>/c 0.0) 1.0]
                      [#:try-@2x? try-@2x? any/c #f])
         (is-a?/c bitmap%)]{

@;{Returns @racket[(make-object bitmap% in kind bg-color
complain-on-failure? backing-scale)], but this procedure is preferred
because it defaults @racket[kind] and @racket[complain-on-failure?] in
a more useful way.}
  返回@racket[(make-object bitmap% in kind bg-color
complain-on-failure? backing-scale)]，但这一程序是首选的，因为它以一种更有用的方式默认@racket[kind]和@racket[complain-on-failure?]。

@;{If @racket[try-@2x?] is true, @racket[in] is a path, and @racket[kind]
is not one of the @racketidfont{/mask} symbols, then
@racket[read-bitmap] checks whether a file exists matching @racket[in]
but with @filepath{@"@"2x} added to the name (before the file suffix,
if any). If the @filepath{@"@"2x} path exists, it is used instead of
@racket[in], and @racket[backing-store] is multiplied by @racket[2].}
  如果@racket[try-@2x?]为真，@racket[in]是一个路径，@racket[kind]不是@racketidfont{/mask}符号之一，然后读取位图检查是否存在与@racket[in]匹配的文件，但名称中添加了@filepath{@"@"2x}（如果有，在文件后缀之前）。如果存在@filepath{@"@"2x}路径，则使用它而不是@racket[in]，并且@racket[backing-store]乘以@racket[2]。

@history[#:changed "1.1" @elem{@;{Added the @racket[#:backing-scale]
and @racket[#:try-@2x?] optional arguments.}添加@racket[#:backing-scale]
和@racket[#:try-@2x?]可选参数。}]}


@defproc[(recorded-datum->procedure [datum any/c]) ((is-a?/c dc<%>) . -> . void?)]{

@;{Converts a value from @xmethod[record-dc% get-recorded-datum] to a drawing procedure.}
将@xmethod[record-dc% get-recorded-datum]值转换为绘图过程。
}


@defthing[the-brush-list (is-a?/c brush-list%)]{

@;{See @racket[brush-list%].}
  参见@racket[brush-list%]。

}

@defthing[the-color-database (is-a?/c color-database<%>)]{

@;{See @racket[color-database<%>].}
参见@racket[color-database<%>]。

}

@defthing[the-font-list (is-a?/c font-list%)]{

@;{See @racket[font-list%].}
  参见@racket[font-list%]。

}

@defthing[the-font-name-directory (is-a?/c font-name-directory<%>)]{

@;{See @racket[font-name-directory<%>].}
参见@racket[font-name-directory<%>]。

}

@defthing[the-pen-list (is-a?/c pen-list%)]{

@;{See @racket[pen-list%].}
  参见@racket[pen-list%]。

}
