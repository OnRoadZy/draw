#lang scribble/doc
@(require "common.rkt"
          scribble/eval
          (for-label racket/draw/unsafe/brush
                     (only-in ffi/unsafe cpointer?)))

@(define class-eval (make-base-eval))
@(interaction-eval #:eval class-eval (require racket/class racket/draw))
@defclass/title[brush% object% ()]{

@;{A brush is a drawing tool with a color and a style that is used for
 filling in areas, such as the interior of a rectangle or ellipse.  In
 a monochrome destination, all non-white brushes are drawn as black.}
  画笔是一种带有颜色和样式的绘图工具，用于填充区域，例如矩形或椭圆的内部。在单色目标中，所有非白色画笔都绘制为黑色。

@;{In addition to its color and style, a brush can have a @deftech{brush stipple} bitmap.
 Painting with a
 stipple brush is similar to calling @method[dc<%> draw-bitmap] with
 the stipple bitmap in the filled region.}
  除了颜色和样式之外，画笔还可以具有画笔点画位图。使用点画画笔进行绘制类似于调用填充区域中点画位图的@method[dc<%> draw-bitmap]。

@;{As an alternative to a color, style, and stipple, a brush can have a
 @deftech{gradient} that is a @racket[linear-gradient%] or
 @racket[radial-gradient%]. When a brush has a gradient and the target
 for drawing is not monochrome, then other brush settings are
 ignored. With a gradient, for each point in a drawing destination,
 the gradient associates a color to the point based on starting and
 ending colors and starting and ending lines (for a linear gradient)
 or circles (for a radial gradient); a gradient-assigned color is
 applied for each point that is touched when drawing with the brush.}
  作为颜色、样式和点画的替代，画笔可以具有@racket[linear-gradient%]或@racket[radial-gradient%]的@deftech{渐变（gradient）}。当画笔具有渐变并且绘制的目标不是单色时，则忽略其他画笔设置。对于渐变，对于绘图目标中的每个点，渐变将基于开始和结束颜色以及开始和结束线（对于线性渐变）或圆（对于径向渐变）将颜色与该点关联；使用画笔绘制时，将为每个点应用渐变指定的颜色。

@;{By default, coordinates in a stipple or gradient are transformed by the
 drawing context's transformation when the brush is used, but a brush
 can have its own @deftech{brush transformation} that is used, instead.
 A brush transformation has the same representation and meaning as for
 @xmethod[dc<%> get-transformation].}
  默认情况下，使用画笔时，点画或渐变中的坐标通过绘图上下文的转换进行转换，但画笔可以使用自己的@deftech{画笔转换（brush transformation）}。画笔转换与 @xmethod[dc<%> get-transformation]具有相同的表示和含义。

@;{A @deftech{brush style} is one of the following (but is ignored if the brush
 has a @tech{gradient} and the target is not monochrome):}
  @deftech{画笔样式（brush style）}是下列之一（但如果画笔具有@tech{渐变（gradient）}且目标不是单色的，则忽略此样式）：

@itemize[

 @item{@indexed-racket['transparent]@;{ --- Draws with no effect (on the
       interior of the drawn shape).}——无效果绘制（在绘制形状的内部）。}

 @item{@indexed-racket['solid]@;{ --- Draws using the brush's color. If a
        monochrome @tech{brush stipple} is installed into the brush, black pixels
        from the stipple are transferred to the destination using the
        brush's color, and white pixels from the stipple are not
        transferred.}——使用画笔的颜色绘制。如果在画笔中安装了单色画笔点画，则使用画笔的颜色将点画中的黑色像素传输到目标，而不会传输点画中的白色像素。}

 @item{@indexed-racket['opaque]@;{ --- The same as @racket['solid] for a color
        @tech{brush stipple}. For a monochrome stipple, white pixels from 
        the stipple are
        transferred to the destination using the destination's
        background color.}——与@racket['solid]用于彩色@tech{画笔点画（brush stipple）}。对于单色点画，使用目标的背景色将点画中的白色像素传输到目标。}

 @item{@indexed-racket['xor]@;{ --- The same as @racket['solid], accepted 
        only for partial backward compatibility.}——与@racket['solid]相同，只接受部分向后兼容性。}

 @item{@indexed-racket['hilite]@;{ --- Draws with black and a @racket[0.3] alpha.}——用黑色和@racket[0.3]alpha绘制。}

 @item{@indexed-racket['panel]@;{ --- The same as @racket['solid], accepted 
        only for partial backward compatibility.}——与@racket['solid]相同，只接受部分向后兼容。}

 @item{@;{The following modes correspond to built-in @tech{brush stipples} drawn in
       @racket['solid] mode:}
         以下模式对应于@racket['solid]模式中绘制的内置画笔点画：

  @itemize[
  @item{@indexed-racket['bdiagonal-hatch]@;{ --- diagonal lines, top-left to bottom-right}——对角线，从左上到右下}
  @item{@indexed-racket['crossdiag-hatch]@;{ --- crossed diagonal lines}交叉对角线}
  @item{@indexed-racket['fdiagonal-hatch]@;{ --- diagonal lines, top-right to bottom-left}——对角线，从右上到左下}
  @item{@indexed-racket['cross-hatch]@;{ --- crossed horizontal and vertical lines}——交叉水平线和垂直线}
  @item{@indexed-racket['horizontal-hatch]@;{ --- horizontal lines}——水平线}
  @item{@indexed-racket['vertical-hatch]@;{ --- vertical lines}——垂直线}
  ]

        @;{However, when a specific @tech{brush stipple} is installed into the brush,
        the above modes are ignored and @racket['solid] is
        used, instead.}
  但是，当在画笔中安装特定的@tech{画笔点画}时，上述模式将被忽略，而是使用@racket['solid]。}

]

@;{@index['("drawing" "outlines")]{To} draw outline shapes (such as
 unfilled boxes and ellipses), use the @racket['transparent] brush
 style.}
  @index['("drawing" "outlines")]{要}绘制轮廓形状（如未填充的方框和椭圆），请使用@racket['transparent]画笔样式。

@;{To avoid creating multiple brushes with the same characteristics, use
 the global @racket[brush-list%] object
 @indexed-racket[the-brush-list], or provide a color and style to
 @xmethod[dc<%> set-brush].}
  要避免创建具有相同特性的多个画笔，请使用全局@racket[brush-list%]对象@indexed-racket[the-brush-list]，或提供颜色和样式以在@xmethod[dc<%> set-brush]。

@;{See also @racket[make-brush].}
另请参见@racket[make-brush]。


@defconstructor[([color (or/c string? (is-a?/c color%)) "black"]
                 [style brush-style/c 'solid]
                 [stipple (or/c #f (is-a?/c bitmap%))
                          #f]
                 [gradient (or/c #f 
                                 (is-a?/c linear-gradient%)
                                 (is-a?/c radial-gradient%))
                           #f]
                 [transformation (or/c #f (vector/c (vector/c real? real? real? 
                                                              real? real? real?)
                                                     real? real? real? real? real?))
                                 #f])]{

@;{Creates a brush with the given color, @tech{brush style}, @tech{brush
 stipple}, @tech{gradient}, and @tech{brush transformation} (which is
 kept only if the gradient or stipple is non-@racket[#f]). For the
 case that the color is specified using a name, see
 @racket[color-database<%>] for information about color names; if the
 name is not known, the brush's color is black.}
  创建具有给定颜色、@tech{画笔样式（brush style）}、@tech{画笔点画（brush
 stipple）}、@tech{渐变（gradient）}和@tech{画笔转换（brush transformation）}的画笔（仅当渐变或点画为非@racket[#f]时才保留）。对于使用名称指定颜色的情况，请参见@racket[color-database<%>]了解有关颜色名称的信息；如果名称未知，则画笔的颜色为黑色。}

@defmethod[(get-color)
           (is-a?/c color%)]{

@;{Returns the brush's color.}
  返回画笔的颜色。

}

@defmethod[(get-gradient)
           (or/c (is-a?/c linear-gradient%)
                 (is-a?/c radial-gradient%)
                 #f)]{

@;{Gets the @tech{gradient}, or @racket[#f] if the brush has no gradient.}
 获取@tech{渐变（gradient）}，如果画笔没有渐变，则返回@racket[#f]。}


@defmethod[(get-handle) (or/c cpointer? #f)]{

@;{Returns a low-level handle for the brush content, but only for brushes
created with @racket[make-handle-brush]; otherwise, the result is @racket[#f].}
 返回画笔内容的低级句柄，但仅用于使用@racket[make-handle-brush]创建的画笔；否则，结果为@racket[#f]。}


@defmethod[(get-stipple)
           (or/c (is-a?/c bitmap%) #f)]{

@;{Gets the @tech{brush stipple} bitmap, or @racket[#f] if the brush has no stipple.}
 获取@tech{画笔点画（brush stipple）}位图，如果画笔没有点画，则为@racket[#f]。}


@defmethod[(get-style)
           brush-style/c]{

@;{Returns the @tech{brush style}. See @racket[brush%] for information about
brush styles.}
  返回@tech{画笔类型（brush style）}。参看@racket[brush%]以获取画笔类型的更多信息。}


@defmethod[(get-transformation) (or/c #f (vector/c (vector/c real? real? real? real? real? real?)
                                                   real? real? real? real? real?))]{

@;{Returns the brush's @tech{brush transformation}, if any.}
  返回画笔的 @tech{画笔转换（brush transformation）}（如果有）。

@;{If a brush with a stipple or gradient also has a transformation, then the
transformation applies to the stipple or gradient's coordinates instead of the
target drawing context's transformation; otherwise, the target drawing
context's transformation applies to stipple and gradient coordinates.}
 如果带有点画或渐变的画笔也有变换，则变换将应用于点画或渐变的坐标，而不是目标绘图上下文的变换；否则，目标绘图上下文的变换将应用于点画和渐变坐标。}


@defmethod[(is-immutable?)
           boolean?]{

@;{Returns @racket[#t] if the brush object is immutable.}
  如果画笔对象不可变，则返回@racket[#t]。

}


@defmethod*[([(set-color [color (is-a?/c color%)])
              void?]
             [(set-color [color-name string?])
              void?]
             [(set-color [red byte?] [green byte?] [blue byte?])
              void?])]{

@;{Sets the brush's color.  A brush cannot be modified if it was obtained
 from a @racket[brush-list%] or while it is selected into a drawing
 context.}
  设置画笔的颜色。如果画笔是从@racket[brush-list%]中获取的，或是在将其选定到绘图上下文中时，则无法对其进行修改。

@;{For the case that the color is specified using a string, see
 @racket[color-database<%>] for information about color names.}
  对于使用字符串指定颜色的情况，请参见@racket[color-database<%>]以获取有关颜色名称的信息。

}

@defmethod[(set-stipple [bitmap (or/c (is-a?/c bitmap%) #f)]
                 [transformation (or/c #f (vector/c (vector/c real? real? real? 
                                                              real? real? real?)
                                                     real? real? real? real? real?))
                                 #f])
           void?]{

@;{Sets or removes the @tech{brush stipple} bitmap, where @racket[#f]
 removes the stipple. The @tech{brush transformation} is set at the
 same time to @racket[transformation]. See @racket[brush%] for
 information about drawing with stipples.}
  设置或删除@tech{画笔点画（brush stipple）}位图，其中@racket[#f]删除点画。@tech{画笔转换（brush transformation）}同时设置为@racket[transformation]。有关用点绘制的信息，请参见@racket[brush%]。

@;{If @racket[bitmap] is modified while is associated with a brush, the
 effect on the brush is unspecified. A brush cannot be modified if it
 was obtained from a @racket[brush-list%] or while it is selected into
 a drawing context.}
  如果@racket[bitmap]在与画笔关联时被修改，则对画笔的影响是未指定的。如果画笔是从@racket[brush-list%]中获取的，或是在将其选定到绘图上下文中时，则无法对其进行修改。

}

@defmethod[(set-style [style brush-style/c])
           void?]{

@;{Sets the @tech{brush style}. See
@racket[brush%] for information about the possible styles.}
 设置@tech{画笔样式（brush style）}。有关可能的样式的信息，请参见@racket[brush%]。 

@;{A brush cannot be modified if it was obtained from a
 @racket[brush-list%] or while it is selected into a drawing
 context.}
  如果画笔是从@racket[brush-list%]中获取的，或是在将其选定到绘图上下文中时，则无法对其进行修改。

}}

@(close-eval class-eval)
