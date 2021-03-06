#lang scribble/doc
@(require "common.rkt")

@definterface/title[dc<%> ()]{

@;{A @racket[dc<%>] object is a drawing context for drawing graphics and
 text.  It represents output devices in a generic way; e.g., a canvas
 has a drawing context, as does a printer.}
  一个@racket[dc<%>]对象是用于绘制图形和文本的绘图上下文。它以通用的方式表示输出设备；例如，一个画布有一个绘图上下文，一个打印机都也一样。


@defmethod[(cache-font-metrics-key)
           exact-integer?]{

@;{Returns an integer that, if not @racket[0], corresponds to a
particular kind of device and scaling factor, such that text-extent
information (from @method[dc<%> get-text-extent], @method[dc<%>
get-char-height], etc.) is the same. The key is valid across all
@racket[dc<%>] instances, even among different classes.}
  返回一个整数，如果不是@racket[0]，则对应于一个特定类型的设备和比例因子，以便文本范围信息（来自 @method[dc<%> get-text-extent]、 @method[dc<%>
get-char-height]等）相同。该键在所有@racket[dc<%>]实例中都有效，即使在不同的类中也是如此。

@;{A @racket[0] result indicates that the current configuration of
@this-obj[] does not fit into a common category, and so no key is
available for caching text-extent information.}
 一个@racket[0]结果表示@this-obj[]的当前配置不属于公共类别，因此没有可用于缓存文本扩展数据块信息的密钥。}


@defmethod[(clear)
           void?]{

@;{Clears the drawing region (fills it with the current background color,
as determined by @method[dc<%> get-background]). See also @method[dc<%> erase].}
清除绘图区域（使用由@method[dc<%> get-background]确定的当前背景色填充）。也可以参见《 @method[dc<%> erase]》。
}

@defmethod[(copy [x real?]
                 [y real?]
                 [width (and/c real? (not/c negative?))]
                 [height (and/c real? (not/c negative?))]
                 [x2 real?]
                 [y2 real?])
           void?]{

@;{Copies the rectangle defined by @racket[x], @racket[y],
@racket[width], and @racket[height] of the drawing context to the same
drawing context at the position specified by @racket[x2] and
@racket[y2]. The source and destination regions can overlap.}
  将由绘图上下文的@racket[x]、@racket[y]、
@racket[width]和@racket[height]定义的矩形区域复制到由 @racket[x2]和@racket[y2]指定的位置处的同一图形上下文。源区域和目标区域可以重叠。

@history[#:changed "1.12" @elem{@;{Allow overlapping source and destination.}允许源和目标重叠。}]}


@defmethod[(draw-arc [x real?]
                     [y real?]
                     [width (and/c real? (not/c negative?))]
                     [height (and/c real? (not/c negative?))]
                     [start-radians real?]
                     [end-radians real?])
           void?]{

@;{Draws a counter-clockwise circular arc, a part of the ellipse
 inscribed in the rectangle specified by @racket[x] (left), @racket[y]
 (top), @racket[width], and @racket[height]. The arc starts at the angle
 specified by @racket[start-radians] (@racket[0] is three o'clock and
 half-pi is twelve o'clock) and continues counter-clockwise to
 @racket[end-radians]. If @racket[start-radians] and @racket[end-radians] are
 the same, a full ellipse is drawn.}
  绘制一个逆时针的圆弧，椭圆的一部分，该椭圆内接在由 @racket[x] （左（left））、@racket[y]
 （顶（top））、@racket[width]和@racket[height]指定的矩形中。圆弧从@racket[start-radians] 指定的角度开始（@racket[0]是3点钟，半圆周率是12点钟），然后逆时针继续到@racket[end-radians]。如果 @racket[start-radians]和@racket[end-radians]相同，则绘制一个完整的椭圆。

@;{The current pen is used for the arc. If the current brush is not
 transparent, it is used to fill the wedge bounded by the arc plus
 lines (not drawn) extending to the center of the inscribed ellipse.
 If both the pen and brush are non-transparent, the wedge is filled
 with the brush before the arc is drawn with the pen.}
  当前画笔用于圆弧。如果当前画笔不是透明的，则用于填充由圆弧加上延伸到内接椭圆中心的线（未绘制）所限定的楔体。如果笔和画笔都是不透明的，则在用笔绘制圆弧之前，楔块中会用画笔填充。

@;{The wedge and arc meet so that no space is left between them, but the
 precise overlap between the wedge and arc is platform- and
 size-specific.  Typically, the regions drawn by the brush and pen
 overlap.  In unsmoothed or aligned mode, the path for the outline is
 adjusted by shrinking the bounding ellipse width and height by, after scaling, one
 drawing unit divided by the alignment scale.}
  楔形和弧形相交，因此它们之间没有空间，但是楔形和弧形之间的精确重叠是平台和尺寸特定的。通常，画笔和笔绘制的区域重叠。在非平滑或对齐模式下，通过缩小边界椭圆的宽度和高度来调整轮廓路径，缩放后，用一个绘图单位除以对齐比例。


@|DrawSizeNote|

}


@defmethod[(draw-bitmap [source (is-a?/c bitmap%)]
                        [dest-x real?]
                        [dest-y real?]
                        [style (or/c 'solid 'opaque 'xor) 'solid]
                        [color (is-a?/c color%) (send the-color-database find-color "black")]
                        [mask (or/c (is-a?/c bitmap%) #f) #f])
           boolean?]{

@;{Displays the @racket[source] bitmap. The @racket[dest-x] and @racket[dest-y] arguments
 are in DC coordinates.}
  显示@racket[source]位图。@racket[dest-x]和@racket[dest-y]参数采用DC坐标。

@;{For color bitmaps, the drawing style and color arguments are
 ignored. For monochrome bitmaps, @method[dc<%> draw-bitmap] uses the
 style and color arguments in the same way that a brush uses its style
 and color settings to draw a monochrome stipple (see @racket[brush%]
 for more information).}
  对于颜色位图，将忽略绘图样式和颜色参数。对于单色位图，@method[dc<%> draw-bitmap]使用样式和颜色参数的方式与画笔使用其样式和颜色设置绘制单色点画的方式相同（有关详细信息，请参见@racket[brush%]。

@;{If a @racket[mask] bitmap is supplied, it must have the same width and height
 as @racket[source], and its @method[bitmap% ok?] must return
 true, otherwise @|MismatchExn|. The @racket[source] bitmap and @racket[mask]
 bitmap can be the same object, but if the drawing context is a
 @racket[bitmap-dc%] object, both bitmaps must be distinct from the
 destination bitmap, otherwise @|MismatchExn|.}
  如果提供了一个@racket[mask]位图，则其宽度和高度必须与@racket[source]及其@method[bitmap% ok?]必须返回true，否则@|MismatchExn|。@racket[source]位图和@racket[mask]位图可以是同一个对象，但如果绘图上下文是一个@racket[bitmap-dc%]对象，则两个位图必须与目标位图不同，否则@|MismatchExn|。

@;{The effect of @racket[mask] on drawing depends on the type of the
@racket[mask] bitmap:}
  @racket[mask]对绘图的影响取决于@racket[mask]位图的类型：

@itemlist[

 @item{@;{If the @racket[mask] bitmap is monochrome, drawing occurs in
       the target @racket[dc<%>] only where the mask bitmap contains
       black pixels (independent of @racket[style], which controls how
       the white pixels of a monochrome @racket[source] are handled).}
   如果@racket[mask]位图是单色的，则仅当遮罩位图包含黑色像素（与@racket[style]无关，后者控制如何处理单色@racket[source]的白色像素）时，才会在目标@racket[dc<%>]中绘制。}

 @item{@;{If the @racket[mask] bitmap is color with an alpha channel, its
       alpha channel is used as the mask for drawing @racket[source],
       and its color channels are ignored.}
   如果@racket[mask]位图是带alpha通道的颜色，则其alpha通道将用作绘制@racket[source]的遮罩，并且其颜色通道将被忽略。}

 @item{@;{If the @racket[mask] bitmap is color without an alpha channel,
       the color components of a given pixel are averaged to arrive at
       an inverse alpha value for the pixel. In particular, if the
       @racket[mask] bitmap is grayscale, then the blackness of each
       mask pixel controls the opacity of the drawn pixel (i.e., the
       mask acts as an inverted alpha channel).}
   如果@racket[mask]位图是没有alpha通道的颜色，则对给定像素的颜色分量进行平均，以获得该像素的逆alpha值。特别是，如果@racket[mask]位图为灰度，则每个遮罩像素的黑度控制绘制像素的不透明度（即，遮罩充当一个倒置的alpha通道）。}

]

@;{The current brush, current pen, and current text for the DC have no
 effect on how the bitmap is drawn, but the bitmap is scaled if the DC
 has a scale, and the DC's alpha setting determines the opacity of the
 drawn pixels (in combination with an alpha channel of @racket[source],
 any given @racket[mask], and the alpha component of @racket[color] 
 when @racket[source] is monochrome).}
  DC的当前画笔、当前笔和当前文本对位图的绘制方式没有影响，但如果DC具有比例，则位图将被缩放，并且DC的alpha设置确定绘制像素的不透明度（结合@racket[source]的alpha通道、任何给定的@racket[mask]以及当@racket[source]为单色时@racket[color]的alpha分量）。

@;{For @racket[post-script-dc%] and @racket[pdf-dc%] output, opacity from
 an alpha channel in @racket[source], from @racket[mask], or from 
 @racket[color] is rounded to full transparency or opacity.}
  对于@racket[post-script-dc%]和 @racket[pdf-dc%]输出，来自@racket[source]中的alpha通道、来自@racket[mask]或来自@racket[color]的不透明度四舍五入为完全透明或不透明。

@;{The result is @racket[#t] if the bitmap is successfully drawn,
 @racket[#f] otherwise (possibly because the bitmap's @method[bitmap%
 ok?] method returns @racket[#f]).}
  如果位图绘制成功，结果是@racket[#t]，否则是@racket[#f]（可能是因为位图的@method[bitmap%
 ok?]方法返回@racket[#f]）。

@;{See also @method[dc<%> draw-bitmap-section].}
  也可参见@method[dc<%> draw-bitmap-section]。

@|DrawSizeNote|

}

@defmethod[(draw-bitmap-section [source (is-a?/c bitmap%)]
                                [dest-x real?]
                                [dest-y real?]
                                [src-x real?]
                                [src-y real?]
                                [src-width (and/c real? (not/c negative?))]
                                [src-height (and/c real? (not/c negative?))]
                                [style (or/c 'solid 'opaque 'xor) 'solid]
                                [color (is-a?/c color%) (send the-color-database find-color "black")]
                                [mask (or/c (is-a?/c bitmap%) #f) #f])
           boolean?]{

@;{Displays part of a bitmap.}
  显示位图的一部分。

@;{The @racket[src-x], @racket[src-y], @racket[src-width], and
 @racket[src-height] arguments specify a rectangle in the source
 bitmap to copy into this drawing context.}
  @racket[src-x]、@racket[src-y]、@racket[src-width]和@racket[src-height]参数指定源位图中要复制到此绘图上下文的矩形。

@;{See @method[dc<%> draw-bitmap] for information about @racket[dest-x],
 @racket[dest-y], @racket[style], @racket[color], and @racket[mask].}
  有关@racket[dest-x]、@racket[dest-y]、 @racket[style]、@racket[color]和@racket[mask]的信息，请参见@method[dc<%> draw-bitmap]。

}

@defmethod[(draw-ellipse [x real?]
                         [y real?]
                         [width (and/c real? (not/c negative?))]
                         [height (and/c real? (not/c negative?))])
           void?]{

@;{Draws an ellipse contained in a rectangle with the given top-left
 corner and size. The current pen is used for the outline, and the
 current brush is used for filling the shape. If both the pen and
 brush are non-transparent, the ellipse is filled with the brush
 before the outline is drawn with the pen.}
  绘制包含在具有给定左上角和大小的矩形中的椭圆。当前笔用于轮廓，当前画笔用于填充形状。如果笔和画笔都是不透明的，则在用笔绘制轮廓之前，椭圆将用画笔填充。

@;{Brush filling and pen outline meet so that no space is left between
 them, but the precise overlap between the filling and outline is
 platform- and size-specific.  Thus, the regions drawn by the brush
 and pen may partially overlap. In unsmoothed or aligned mode, the
 path for the outline is adjusted by, after scaling, shrinking the
 ellipse width and height by one drawing unit divided by the
 @tech{alignment scale}.}
  画笔填充和笔轮廓相吻合，这样它们之间就没有空间了，但是填充和轮廓之间的精确重叠是平台和尺寸特定的。因此，画笔和笔绘制的区域可能部分重叠。在非平滑或对齐模式下，轮廓的路径在缩放后通过一个绘图单位除以@tech{对齐比例}来调整椭圆的宽度和高度。

@|DrawSizeNote|

}

@defmethod[(draw-line [x1 real?]
                      [y1 real?]
                      [x2 real?]
                      [y2 real?])
           void?]{

@;{Draws a line from one point to another.  The current pen is used for
 drawing the line.}
 从一点到另一点画一条线。当前笔用于绘制线条。

@;{In unsmoothed mode, the points correspond to pixels, and the line
 covers both the start and end points. For a pen whose scaled width is
 larger than @racket[1], the line is drawn centered over the start and
 end points.}
  在非平滑模式下，点对应于像素，线条覆盖起点和终点。对于一个宽度大于@racket[1]的笔，画的线是以起点和终点为中心的。

@;{See also @method[dc<%> set-smoothing] for information on the
@racket['aligned] smoothing mode.}
  另请参见@method[dc<%> set-smoothing]了解有关@racket['aligned]平滑模式的信息。

@|DrawSizeNote|

}

@defmethod[(draw-lines [points (or/c (listof (is-a?/c point%))
                                     (listof (cons/c real? real?)))]
                       [xoffset real? 0]
                       [yoffset real? 0])
           void?]{

@;{Draws lines using a list @racket[points] of points, adding @racket[xoffset]
 and @racket[yoffset] to each point. A pair is treated as a point where the
 @racket[car] of the pair is the x-value and the @racket[cdr] is the y-value.
 The current pen is used for
 drawing the lines.}
  使用点的列表@racket[points]绘制线，向每个点添加@racket[xoffset]和@racket[yoffset]。一个配对被视为一个点，其中配对的@racket[car]是x值，@racket[cdr]是y值。当前笔用于绘制线条。

@;{See also @method[dc<%> set-smoothing] for information on the
 @racket['aligned] smoothing mode.}
  另请参见@method[dc<%> set-smoothing]了解有关@racket['aligned]平滑模式的信息。

@|DrawSizeNote|

}

@defmethod[(draw-path [path (is-a?/c dc-path%)]
                      [xoffset real? 0]
                      [yoffset real? 0]
                      [fill-style (or/c 'odd-even 'winding) 'odd-even])
           void?]{

@;{Draws the sub-paths of the given @racket[dc-path%] object, adding
 @racket[xoffset] and @racket[yoffset] to each point. (See
 @racket[dc-path%] for general information on paths and sub-paths.)
 The current pen is used for drawing the path as a line, and the
 current brush is used for filling the area bounded by the path.}
  绘制给定 @racket[dc-path%]对象的子路径，将@racket[xoffset]和@racket[yoffset]添加到每个点。（有关路径和子路径的一般信息，请参见@racket[dc-path%]）当前笔用于将路径绘制为直线，当前画笔用于填充路径边界区域。

@;{If both the pen and brush are non-transparent, the path is filled with
 the brush before the outline is drawn with the pen. The filling and
 outline meet so that no space is left between them, but the precise
 overlap between the filling and outline is platform- and
 size-specific.  Thus, the regions drawn by the brush and pen may
 overlap. More generally, the pen is centered over the path, rounding
 left and down in unsmoothed mode.}
  如果笔和画笔都是不透明的，则在使用笔绘制轮廓之前，将使用画笔填充路径。填充和轮廓相交，因此它们之间没有空间，但是填充和轮廓之间的精确重叠是平台和尺寸特定的。因此，画笔和笔绘制的区域可能重叠。通常情况下，笔在路径上居中，以非平滑模式向左和向下取整。

@;{The @racket[fill-style] argument specifies the fill rule:
 @racket['odd-even] or @racket['winding]. In @racket['odd-even] mode, a
 point is considered enclosed within the path if it is enclosed by an
 odd number of sub-path loops. In @racket['winding] mode, a point is
 considered enclosed within the path if it is enclosed by more or less
 clockwise sub-path loops than counter-clockwise sub-path loops.}
   @racket[fill-style]参数指定填充规则：@racket['odd-even]或@racket['winding]。在@racket['odd-even]模式下，如果一个点被奇数个子路径循环包围，则该点被视为封闭在路径中。在@racket['winding]模式下，如果一个点被多余或少于顺时针子路径循环包围，而不是逆时针子路径循环包围，则认为该点被包围在路径内。

@;{See also @method[dc<%> set-smoothing] for information on the
 @racket['aligned] smoothing mode.}
  另请参见@method[dc<%> set-smoothing]了解有关@racket['aligned]平滑模式的信息。

@|DrawSizeNote|

}

@defmethod[(draw-point [x real?]
                       [y real?])
           void?]{

@;{Plots a single point using the current pen.}
  使用当前笔绘制单点。

@|DrawSizeNote|

}

@defmethod[(draw-polygon [points (or/c (listof (is-a?/c point%))
                                       (listof (cons/c real? real?)))]
                         [xoffset real? 0]
                         [yoffset real? 0]
                         [fill-style (or/c 'odd-even 'winding) 'odd-even])
           void?]{

@;{Draw a filled polygon using a list @racket[points] of points, adding
 @racket[xoffset] and @racket[yoffset] to each point. 
 A pair is treated as a point where the
 @racket[car] of the pair is the x-value and the @racket[cdr] is the y-value.
 The polygon is
 automatically closed, so the first and last point can be
 different. The current pen is used for drawing the outline, and the
 current brush for filling the shape.}
  使用点列表@racket[points]绘制一个填充多边形，向每个点添加@racket[xoffset]和@racket[yoffset]。一个配对被视为@racket[car]是x值，而@racket[cdr]是y值。多边形自动闭合，因此第一个点和最后一个点可以不同。当前笔用于绘制轮廓，当前画笔用于填充形状。

@;{If both the pen and brush are non-transparent, the polygon is filled
 with the brush before the outline is drawn with the pen. The filling
 and outline meet so that no space is left between them, but the
 precise overlap between the filling and outline is platform- and
 shape-specific.  Thus, the regions drawn by the brush and pen may
 overlap. More generally, the pen is centered over the polygon lines,
 rounding left and down in unsmoothed mode.}
  如果钢笔和画笔都是不透明的，则在用钢笔绘制轮廓之前，多边形将用画笔填充。填充和轮廓相交，因此它们之间没有空间，但是填充和轮廓之间的精确重叠是平台和形状特定的。因此，画笔和笔绘制的区域可能重叠。通常情况下，笔在多边形线上居中，以非平滑模式向左和向下取整。

@;{The @racket[fill-style] argument specifies the fill rule:
 @racket['odd-even] or @racket['winding]. In @racket['odd-even] mode, a
 point is considered enclosed within the polygon if it is enclosed by
 an odd number of loops. In @racket['winding] mode, a point is
 considered enclosed within the polygon if it is enclosed by more or
 less clockwise loops than counter-clockwise loops.}
  @racket[fill-style]参数指定填充规则：@racket['odd-even]或@racket['winding]。在@racket['odd-even]模式下，如果一个点被奇数圈包围，则该点被视为封闭在多边形内。在@racket['winding]模式下，如果一个点被多于或少于逆时针圈的顺时针圈包围，则认为该点被包围在多边形内。

@;{See also @method[dc<%> set-smoothing] for information on the
 @racket['aligned] smoothing mode.}
  另请参见 @method[dc<%> set-smoothing]了解有关@racket['aligned]平滑模式的信息。

@|DrawSizeNote|

}


@defmethod[(draw-rectangle [x real?]
                           [y real?]
                           [width (and/c real? (not/c negative?))]
                           [height (and/c real? (not/c negative?))])
           void?]{

@;{Draws a rectangle with the given top-left corner and size.  The
 current pen is used for the outline and the current brush for filling
 the shape. If both the pen and brush are non-transparent, the
 rectangle is filled with the brush before the outline is drawn with
 the pen.}
  
绘制具有给定左上角和大小的矩形。当前笔用于轮廓，当前画笔用于填充形状。如果笔和画笔都是不透明的，则在用笔绘制轮廓之前，矩形中会填充画笔。 

@;{In unsmoothed or aligned mode, when the pen is size 0 or 1, the
 filling precisely overlaps the entire outline. More generally, in
 unsmoothed or aligned mode, the path for the outline is adjusted by
 shrinking the rectangle width and height by, after scaling, one
 drawing unit divided by the @tech{alignment scale}.}
  在非平滑或对齐模式下，当笔的大小为0或1时，填充会精确地重叠整个轮廓。通常，在非平滑或对齐模式下，通过缩小矩形的宽度和高度来调整轮廓路径，缩放后，通过@tech{对齐比例}分割一个绘图单位。

@;{See also @method[dc<%> set-smoothing] for information on the
@racket['aligned] smoothing mode.}
  另请参见@method[dc<%> set-smoothing]了解有关@racket['aligned]平滑模式的信息。

@|DrawSizeNote|

}


@defmethod[(draw-rounded-rectangle [x real?]
                                   [y real?]
                                   [width (and/c real? (not/c negative?))]
                                   [height (and/c real? (not/c negative?))]
                                   [radius real? -0.25])
           void?]{

@;{Draws a rectangle with the given top-left corner, and with the given
 size. The corners are quarter-circles using the given radius.  The
 current pen is used for the outline and the current brush for filling
 the shape. If both the pen and brush are non-transparent, the rectangle is filled
 with the brush before the outline is drawn with the pen.}
 绘制具有给定左上角和给定大小的矩形。角是使用给定半径的四分之一圆。当前笔用于轮廓，当前画笔用于填充形状。如果笔和画笔都是不透明的，则矩形将被填充。在用钢笔画轮廓之前用刷子。 

@;{If @racket[radius] is positive, the value is used as the radius of the
 rounded corner. If @racket[radius] is negative, the absolute value is
 used as the @italic{proportion} of the smallest dimension of the
 rectangle.}
  如果@racket[radius]为正数，则该值将用作圆角的半径。如果@racket[radius]为负数，则绝对值将用作矩形最小尺寸的 @italic{比例}。

@;{If @racket[radius] is less than @racket[-0.5] or more than half of
 @racket[width] or @racket[height], @|MismatchExn|.}
  如果@racket[radius]小于@racket[-0.5]或大于@racket[width]或@racket[height]的一半，@|MismatchExn|。

@;{Brush filling and pen outline meet so that no space is left between
 them, but the precise overlap between the filling and outline is
 platform- and size-specific.  Thus, the regions drawn by the brush
 and pen may partially overlap. In unsmoothed or aligned mode, the
 path for the outline is adjusted by, after scaling, shrinking the
 rectangle width and height by one drawing unit divided by the
 @tech{alignment scale}.}
  画笔填充和笔轮廓相吻合，这样它们之间就没有空间了，但是填充和轮廓之间的精确重叠是平台和尺寸特定的。因此，画笔和笔绘制的区域可能部分重叠。在非平滑或对齐模式下，轮廓的路径在缩放后通过一个绘图单位除以@tech{对齐比例}来调整矩形的宽度和高度。

@;{See also @method[dc<%> set-smoothing] for information on the
@racket['aligned] smoothing mode.}
 另请参见@method[dc<%> set-smoothing]了解有关@racket['aligned]平滑模式的信息。 

@|DrawSizeNote|

}

@defmethod[(draw-spline [x1 real?]
                        [y1 real?]
                        [x2 real?]
                        [y2 real?]
                        [x3 real?]
                        [y3 real?])
           void?]{

@;{@index['("drawing curves")]{Draws} a spline from (@racket[x1],
 @racket[y1]) to (@racket[x3], @racket[y3]) using (@racket[x2],
 @racket[y2]) as the control point.}
  @index['("drawing curves")]{使用}(@racket[x2],  @racket[y2])作为控制点，从(@racket[x1],
 @racket[y1])到(@racket[x3], @racket[y3])绘制样条。

@;{See also @method[dc<%> set-smoothing] for information on the
 @racket['aligned] smoothing mode. See also @racket[dc-path%] and
 @method[dc<%> draw-path] for drawing more complex curves.}
  另请参见@method[dc<%> set-smoothing]了解有关@racket['aligned]平滑模式的信息。另请参见@racket[dc-path%]和@method[dc<%> draw-path]以绘制更复杂的曲线。

@|DrawSizeNote|

}

@defmethod[(draw-text [text string?]
                      [x real?]
                      [y real?]
                      [combine? any/c #f]
                      [offset exact-nonnegative-integer? 0]
                      [angle real? 0])
           void?]{

@;{Draws a text string at a specified point, using the current text font,
 and the current text foreground and background colors. For unrotated
 text, the specified point is used as the starting top-left point for
 drawing characters (e.g, if ``W'' is drawn, the point is roughly the
 location of the top-left pixel in the ``W''). Rotated text is rotated
 around this point.}
  使用当前文本字体、当前文本前景色和背景色在指定点绘制文本字符串。对于未汇总的文本，指定的点用作绘制字符的左上角起点（例如，如果绘制了“W”，则该点大致是“W”中左上角像素的位置）。旋转的文本围绕该点旋转。

@;{The @racket[text] string is drawn starting from the @racket[offset]
 character, and continuing until the end of @racket[text] or the first
 null character.}
  @racket[text]字符串从@racket[offset]字符开始绘制，一直绘制到@racket[text]或第一个空字符结束。

@;{If @racket[combine?] is @racket[#t], then @racket[text] may be
 measured with adjacent characters combined to ligature glyphs, with
 Unicode combining characters as a single glyph, with kerning, with
 right-to-left rendering of characters, etc. If @racket[combine?] is
 @racket[#f], then the result is the same as if each character is
 measured separately, and Unicode control characters are ignored.}
  如果@racket[combine?]是@racket[#t]，那么@racket[text]可以用相邻字符组合到连字符来测量，Unicode组合字符作为单个连字符，用紧排，用从右到左的字符呈现等。如果是@racket[combine?]为@racket[#f]，则结果与单独测量每个字符的结果相同，并且忽略Unicode控制字符。

@;{The string is rotated by @racket[angle] radians counter-clockwise. If
 @racket[angle] is not zero, then the text is always drawn in
 transparent mode (see @method[dc<%> set-text-mode]).}
  字符串逆时针旋转@racket[angle]弧度。如果@racket[angle]不是零，则文本始终以透明模式绘制（请参见 @method[dc<%> set-text-mode]）。

@;{The current brush and current pen settings for the DC have no effect
 on how the text is drawn.}
  DC的当前画笔和当前笔设置对文本的绘制方式没有影响。

@;{See @method[dc<%> get-text-extent] for information on the size of the
 drawn text.}
  有关绘制文本的大小信息，请参见@method[dc<%> get-text-extent]。

@;{See also @method[dc<%> set-text-foreground], @method[dc<%>
 set-text-background], and @method[dc<%> set-text-mode].}
  另请参见@method[dc<%> set-text-foreground]、@method[dc<%>
 set-text-background]和@method[dc<%> set-text-mode]。

@|DrawSizeNote|

}

@defmethod[(end-doc)
           void?]{

@;{Ends a document, relevant only when drawing to a printer, PostScript,
 PDF, or SVG device.}
  结束文档，仅在绘制到打印机、PostScript、PDF或SVG设备时相关。

@;{For relevant devices, an exception is raised if
@method[dc<%> end-doc] is called when the document is not started with
@method[dc<%> start-doc], when a page is currently started by
@method[dc<%> start-page] and not ended with @method[dc<%> end-page],
or when the document has been ended already.}
  对于相关设备，如果在文档不是以@method[dc<%> start-doc]启动时调用@method[dc<%> end-doc]，当页面当前是由@method[dc<%> start-page]启动而不是以@method[dc<%> start-page]结束时调用，或者文档已经结束时调用@method[dc<%> end-page]，则会引发异常。

}


@defmethod[(end-page)
           void?]{

@;{Ends a single page, relevant only when drawing to a printer,
 PostScript, PDF, or SVG device.}
仅当绘图到打印机、PostScript、PDF或SVG设备时，才结束一页。

@;{For relevant devices, an exception is raised if
@method[dc<%> end-page] is called when a page is not currently started by
@method[dc<%> start-page].}
 对于相关设备，如果@method[dc<%> end-page]在当前未由@method[dc<%> start-page]启动页面时调用，则会引发异常。}


@defmethod[(erase)
           void?]{

@;{For a drawing context that has an alpha channel, @method[dc<%> erase]
sets all alphas to zero. Similarly, for a transparent canvas,
@method[dc<%> erase] erases all drawing to allow the background window
to show through. For other drawing contexts that have no alpha channel
or transparency, @method[dc<%> erase] fills the drawing context with
white.}
 对于具有alpha通道的绘图上下文，@method[dc<%> erase]将所有alphas设置为零。同样，对于透明画布，@method[dc<%> erase]会擦除所有绘图，以允许背景窗口显示。对于没有alpha通道或透明度的其它绘图上下文，@method[dc<%> erase]将绘图上下文填充为白色。}


@defmethod[(flush) void?]{

@;{Calls the @xmethod[canvas<%> flush] method for
@racket[canvas<%>] output, and has no effect for other kinds of
drawing contexts.}
 为@racket[canvas<%>]输出调用@xmethod[canvas<%> flush]方法，并且对其他类型的绘图上下文无效。}

@defmethod[(get-alpha)
           (real-in 0 1)]{

@;{Gets the current opacity for drawing; see
@method[dc<%> set-alpha].}
  获取绘图的当前不透明度；请参见@method[dc<%> set-alpha]。

}

@defmethod[(get-background)
           (is-a?/c color%)]{

@;{Gets the color used for painting the background. See also
@method[dc<%> set-background].}
获取用于绘制背景的颜色。另见@method[dc<%> set-background]。
}

@defmethod[(get-backing-scale)
           (>/c 0.0)]{

@;{Returns the @tech{backing scale} of the drawing context's destination.}
  返回绘图上下文目标的@tech{背衬比例（backing scale）}。

@history[#:added "1.12"]}


@defmethod[(get-brush)
           (is-a?/c brush%)]{

@;{Gets the current brush. See also @method[dc<%> set-brush].}
 获取当前画笔。另见@method[dc<%> set-brush]。

}

@defmethod[(get-char-height)
           (and/c real? (not/c negative?))]{

@;{Gets the height of a character using the current font.}
  获取使用当前字体的字符高度。

@;{Unlike most methods, this method can be called for a
 @racket[bitmap-dc%] object without a bitmap installed.}
  与大多数方法不同，此方法可以在不安装位图的情况下为@racket[bitmap-dc%]对象调用。

}

@defmethod[(get-char-width)
           (and/c real? (not/c negative?))]{

@;{Gets the average width of a character using the current font.}
  获取使用当前字体的字符的平均宽度。

@;{Unlike most methods, this method can be called for a
 @racket[bitmap-dc%] object without a bitmap installed.}
与大多数方法不同，此方法可以在不安装位图的情况下为@racket[bitmap-dc%]对象调用。
}

@defmethod[(get-clipping-region)
           (or/c (is-a?/c region%) #f)]{

@;{Gets the current clipping region, returning @racket[#f] if the drawing
 context is not clipped (i.e., the clipping region is the entire
 drawing region).}
  获取当前剪切区域，如果绘图上下文未被剪切（即剪切区域是整个绘图区域），则返回@racket[#f]。

}

@defmethod[(get-device-scale)
           (values (and/c real? (not/c negative?))
                   (and/c real? (not/c negative?)))]{

@;{Gets an ``external'' scaling factor for drawing coordinates to the
target device. For most DCs, the result is @racket[1.0] and
@racket[1.0].}
  获取用于向目标设备绘制坐标的“外部”缩放因子。对于大多数分布式控制系统，结果是@racket[1.0]和@racket[1.0]。

@;{A @racket[post-script-dc%] or @racket[pdf-dc%] object returns scaling
factors determined via @xmethod[ps-setup% get-scaling] at the time
that the DC was created. A @racket[printer-dc%] may also have a
user-configured scaling factor.}
 @racket[post-script-dc%]或@racket[pdf-dc%]对象返回在创建DC时通过@xmethod[ps-setup% get-scaling]确定的缩放系数。@racket[printer-dc%]也可能具有用户配置的比例因子。}


@defmethod[(get-font)
           (is-a?/c font%)]{

@;{Gets the current font. See also @method[dc<%> set-font].}
 获取当前字体。另见@method[dc<%> set-font]。 

}

@defmethod[(get-gl-context)
           (or/c (is-a?/c gl-context<%>) #f)]{

@;{Returns a @racket[gl-context<%>] object for this drawing context
 if it supports OpenGL, @racket[#f] otherwise.}
  如果此绘图上下文支持OpenGL，则返回该绘图上下文的@racket[gl-context<%>]对象，否则返回@racket[#f]。

@;{See @racket[gl-context<%>] for more information.}
  有关详细信息，请参阅@racket[gl-context<%>]。

}

@defmethod[(get-initial-matrix)
           (vector/c real? real? real? real? real? real?)]{

@;{Returns a transformation matrix that converts logical coordinates to
 device coordinates. The matrix applies before additional origin
 offset, scaling, and rotation.}
  返回将逻辑坐标转换为设备坐标的转换矩阵。该矩阵在附加原点偏移、缩放和旋转之前应用。

@;{The vector content corresponds to a transformation matrix in the
following order:}
  矢量内容对应于以下顺序的变换矩阵：

@itemlist[

 @item{@racket[_xx]: @;{a scale from the logical @racket[_x] to the device @racket[_x]}从逻辑@racket[_x]到设备@racket[_x]的比例}

 @item{@racket[_xy]: @;{a scale from the logical @racket[_x] added to the device @racket[_y]}从添加到设备@racket[_y]的逻辑@racket[_x]开始的刻度}

 @item{@racket[_yx]: @;{a scale from the logical @racket[_y] added to the device @racket[_x]}从添加到设备@racket[_x]的逻辑@racket[_y]开始的刻度}

 @item{@racket[_yy]: @;{a scale from the logical @racket[_y] to the device @racket[_y]}从逻辑@racket[_y]到设备@racket[_y]的比例}

 @item{@racket[_x0]: @;{an additional amount added to the device @racket[_x]}添加到设备@racket[_x]的额外数量}

 @item{@racket[_y0]: @;{an additional amount added to the device @racket[_y]}添加到设备@racket[_y]的附加量}

]

@;{See also @method[dc<%> set-initial-matrix] and @method[dc<%> get-transformation].}
  另请参见@method[dc<%> set-initial-matrix]和@method[dc<%> get-transformation]。

}


@defmethod[(get-origin)
           (values real? real?)]{

@;{Returns the device origin, i.e., the location in device coordinates of
 @math{(0,0)} in logical coordinates. The origin offset applies after
 the initial transformation matrix, but before scaling and rotation.}
  返回设备原点，即在逻辑坐标中， @math{(0,0)}在设备坐标中的位置。原点偏移应用于初始变换矩阵之后，但在缩放和旋转之前。

@;{See also @method[dc<%> set-origin] and @method[dc<%> get-transformation].}
  另请参见@method[dc<%> set-origin]和@method[dc<%> get-transformation]。

}


@defmethod[(get-pen)
           (is-a?/c pen%)]{

@;{Gets the current pen. See also @method[dc<%> set-pen].}
  获取当前笔。另见@method[dc<%> set-pen]。

}
                     
                          
@defmethod[(get-path-bounding-box [path (is-a?/c dc-path%)] 
                                  [type (or/c 'path 'stroke 'fill)])
           (values real? real? real? real?)]{
@;{Returns a rectangle that encloses the path’s points. 
The return values are the left, top, width, and, height of the rectangle.
The numbers are in logical coordinates.}
  返回一个包含路径点的矩形。返回值为矩形的左、上、宽和高。数字以逻辑坐标表示。

@;{For the type @racket['stroke] the rectangle covers the area that would be affected (``inked'')
when drawn with the current pen by draw-path in the drawing context (with a transparent brush). 
If the pen width is zero, then an empty rectangle will be returned. The size and clipping of the 
drawing context is ignored.}
  对于@racket['stroke]（笔划）类型，矩形覆盖了在绘图上下文（使用透明画笔）中通过绘制路径使用当前笔绘制时将受影响的区域（“墨迹（inked）”）。如果笔宽为零，则返回一个空矩形。忽略图形上下文的大小和剪裁。

@;{For the type @racket['fill] the rectangle covers the area that would be affected (``inked'')
by draw-path in the drawing context (with a non-transparent pen and brush). If the line width 
is zero, then an empty rectangle will be returned. The size and clipping of the drawing
context are ignored.}
对于@racket['fill]（填充）类型，矩形覆盖绘图上下文中绘制路径（使用不透明的笔和画笔）将影响的区域（“墨迹”）。如果线宽为零，则返回一个空矩形。图形上下文的大小和剪裁将被忽略。

@;{For the type @racket['path] the rectangle covers the path, but the pen and brush are ignored.
The size and clipping of the drawing context are also ignored.
More precisely: The result is defined as the limit of the bounding boxes returned
by the @racket['stroke] type for line widths approaching 0 with a round pen cap. The ``limit
process'' stops when an empty rectangle is returned. This implies that zero-area segments 
contributes to the rectangle.}
  对于@racket['path]（路径）类型，矩形覆盖路径，但笔和画笔被忽略。图形上下文的大小和剪裁也将被忽略。更准确地说：结果被定义为@racket['stroke]（笔划）类型返回的边界框的限制，因为线条宽度接近0且带有圆笔帽。当返回空矩形时，“限制进程（limit
process）”停止。这意味着零区域段对矩形有贡献。

@;{For all types if the path is empty, then an empty rectangle @racket[(values 0 0 0 0)] 
will be returned.}
  对于所有类型，如果路径为空，则返回空矩形@racket[(values 0 0 0 0)] 。
}
 

@defmethod[(get-rotation) real?]{

@;{Returns the rotation of logical coordinates in radians to device
coordinates. Rotation applies after the initial transformation matrix,
origin offset, and scaling.}
  返回以弧度表示的逻辑坐标到设备坐标的旋转。旋转应用于初始变换矩阵、原点偏移和缩放之后。

@;{See also @method[dc<%> set-rotation] and @method[dc<%> get-transformation].}
  另见@method[dc<%> set-rotation]和@method[dc<%> get-transformation]。

}

@defmethod[(get-scale)
           (values real? real?)]{

@;{Returns the scaling factor that maps logical coordinates to device
coordinates. Scaling applies after the initial transformation matrix
and origin offset, but before rotation.}
  返回将逻辑坐标映射到设备坐标的比例因子。缩放应用于初始变换矩阵和原点偏移之后，但在旋转之前。

@;{See also @method[dc<%> set-scale] and @method[dc<%> get-transformation].}
另见@method[dc<%> set-scale]和@method[dc<%> get-transformation]。
}

@defmethod[(get-size)
           (values (and/c real? (not/c negative?))
                   (and/c real? (not/c negative?)))]{

@;{Gets the size of the destination drawing area. For a @racket[dc<%>]
 object obtained from a @racket[canvas<%>], this is the (virtual
 client) size of the destination window; for a @racket[bitmap-dc%]
 object, this is the size of the selected bitmap (or 0 if no bitmap is
 selected); for a @racket[post-script-dc%] or @racket[printer-dc%]
 drawing context, this gets the horizontal and vertical size of the
 drawing area.}
  获取目标绘图区域的大小。对于从@racket[canvas<%>]获取的@racket[dc<%>]对象，这是目标窗口的（虚拟客户端）大小；对于@racket[bitmap-dc%]对象，这是所选位图的大小（如果未选择位图，则为0）；对于@racket[post-script-dc%]或@racket[printer-dc%]绘图上下文，这将获取绘图区域的水平和垂直大小。

}

@defmethod[(get-smoothing)
           (or/c 'unsmoothed 'smoothed 'aligned)]{

@;{Returns the current smoothing mode. See @method[dc<%> set-smoothing].}
  返回当前平滑模式。参见@method[dc<%> set-smoothing]。

}

@defmethod[(get-text-background)
           (is-a?/c color%)]{

@;{Gets the current text background color. See also @method[dc<%>
set-text-background].}
  获取当前文本背景色。另请参见@method[dc<%>
set-text-background]。

}

@defmethod[(get-text-extent [string string?]
                            [font (or/c (is-a?/c font%) #f) #f]
                            [combine? any/c #f]
                            [offset exact-nonnegative-integer? 0])
           (values (and/c real? (not/c negative?)) 
                   (and/c real? (not/c negative?))
                   (and/c real? (not/c negative?)) 
                   (and/c real? (not/c negative?)))]{


@;{Returns the size of @racket[str] as it would be drawn in the drawing
 context, starting from the @racket[offset] character of @racket[str],
 and continuing until the end of @racket[str] or the first null
 character.  The @racket[font] argument specifies the font to use in
 measuring the text; if it is @racket[#f], the current font of the
 drawing area is used. (See also @method[dc<%> set-font].)}
  返回将在绘图上下文中绘制的@racket[str]的大小，从@racket[str]的@racket[offset]字符开始，一直到@racket[str]或第一个空字符结束。@racket[font]参数指定用于测量文本的字体；如果它是@racket[#f]，则使用绘图区域的当前字体。（另请参见@method[dc<%> set-font]。）

@;{The result is four real numbers:}
  结果是四个实数：

@itemize[

 @item{@;{the total width of the text (depends on both the font and the
 text);}
   文本的总宽度（取决于字体和文本）；}

 @item{@;{the total height of the font (depends only on the font);}
   字体的总高度（仅取决于字体）；}

 @item{@;{the distance from the baseline of the font to the bottom of the
 descender (included in the height, depends only on the font); and}
   字体基线到下伸器底部的距离（包括在高度中，仅取决于字体）；以及}

 @item{@;{extra vertical space added to the font by the font designer
 (included in the height, and often zero; depends only on the font).}
   字体设计器添加到字体的额外垂直空间（包括在高度中，通常为零；仅取决于字体）。}

]

@;{The returned width and height define a rectangle is that guaranteed to
 contain the text string when it is drawn, but the fit is not
 necessarily tight. Some undefined number of pixels on the left,
 right, top, and bottom of the drawn string may be ``whitespace,''
 depending on the whims of the font designer and the platform-specific
 font-scaling mechanism.}
  返回的宽度和高度定义了一个矩形，它保证在绘制时包含文本字符串，但不一定紧密匹配。根据字体设计人员的想法和平台特定的字体缩放机制，绘制字符串左侧、右侧、顶部和底部的一些未定义的像素可能是“空白”。

@;{If @racket[combine?] is @racket[#t], then @racket[text] may be drawn
 with adjacent characters combined to ligature glyphs, with Unicode
 combining characters as a single glyph, with kerning, with
 right-to-left ordering of characters, etc. If @racket[combine?] is
 @racket[#f], then the result is the same as if each character is
 drawn separately, and Unicode control characters are ignored.}
  如果@racket[combine?]是@racket[#t]，那么@racket[text]可以用相邻的字符组合到连字符，用Unicode组合字符作为一个单个连字符，用紧排，用从右到左的字符顺序绘制，等等。如果是@racket[combine?]为@racket[#f]，则结果与单独绘制每个字符的结果相同，并且忽略Unicode控制字符。

@;{Unlike most methods, this method can be called for a
 @racket[bitmap-dc%] object without a bitmap installed.}
  与大多数方法不同，此方法可以在不安装位图的情况下为@racket[bitmap-dc%]对象调用。


 @examples[
 #:eval (make-base-eval '(require racket/class racket/draw))
 (define text-size-dc (new bitmap-dc% [bitmap (make-object bitmap% 1 1)]))
 (send text-size-dc get-text-extent "Pickles")]
}


@defmethod[(get-text-foreground)
           (is-a?/c color%)]{

@;{Gets the current text foreground color. See also @method[dc<%>
set-text-foreground].}
  获取当前文本前景色。另请参见@method[dc<%>
set-text-foreground]。

}


@defmethod[(get-text-mode)
           (or/c 'solid 'transparent)]{
@;{Reports how text is drawn; see
@method[dc<%> set-text-mode].}
 报告如何绘制文本；请参见@method[dc<%> set-text-mode]。}


@defmethod[(get-transformation)
           (vector/c (vector/c real? real? real? real? real? real?)
                     real? real? real? real? real?)]{

@;{Returns the current transformation setting of the drawing context in a
form that is suitable for restoration via @method[dc<%>
set-transformation].}
  以适合通过@method[dc<%>
set-transformation]还原的形式返回绘图上下文的当前转换设置。

@;{The vector content is as follows:}
  矢量内容如下：

@itemlist[

 @item{@;{the initial transformation matrix; see @method[dc<%>
       get-initial-matrix];}
   初始变换矩阵；见@method[dc<%>
       get-initial-matrix]；}

 @item{@;{the X and Y origin; see @method[dc<%> get-origin];}
   x和y原点；见@method[dc<%> get-origin]；}

 @item{@;{the X and Y scale; see @method[dc<%> get-origin];}
   x和y比例；见@method[dc<%> get-origin]；}

 @item{@;{a rotation; see @method[dc<%> get-rotation].}
   旋转；参见@method[dc<%> get-rotation]。}

]}


@defmethod[(glyph-exists? [c char?])
           boolean?]{

@;{Returns @racket[#t] if the given character has a corresponding glyph
 for this drawing context, @racket[#f] otherwise.}
  如果给定字符具有此绘图上下文的对应glyph，则返回@racket[#t]，否则返回[#f]。 

@;{Due to automatic font substitution when drawing or measuring text, the
 result of this method does not depend on the given font, which merely
 provides a hint for the glyph search. If the font is @racket[#f], the
 drawing context's current font is used. The result depends on the
 type of the drawing context, but the result for @racket[canvas%]
 @racket[dc<%>] instances and @racket[bitmap-dc%] instances is always
 the same for a given platform and a given set of installed fonts.}
由于在绘制或测量文本时自动进行字体替换，该方法的结果不依赖于给定的字体，只为字形搜索提供提示。如果字体为@racket[#f]，则使用绘图上下文的当前字体。结果取决于绘图上下文的类型，但@racket[canvas%]
 @racket[dc<%>]实例和 @racket[bitmap-dc%]实例的结果对于给定的平台和给定的已安装字体集始终相同。

@;{See also @method[font% screen-glyph-exists?] .}
  另请参见@method[font% screen-glyph-exists?]。

}

@defmethod[(ok?)
           boolean?]{

@;{Returns @racket[#t] if the drawing context is usable.}
如果绘图上下文可用，则返回@racket[#t]。
}


@defmethod[(resume-flush) void?]{

@;{Calls the @xmethod[canvas<%> resume-flush] method for
@racket[canvas<%>] output, and has no effect for other kinds of
drawing contexts.}
 对@racket[canvas<%>]输出调用@xmethod[canvas<%> resume-flush]方法，对其它类型的绘图上下文无效。}


@defmethod[(rotate [angle real?]) void?]{

@;{Adds a rotation of @racket[angle] radians to the drawing context's
current transformation.}
  将@racket[angle]弧度的旋转添加到绘图上下文的当前转换中。

@;{Afterward, the drawing context's transformation is represented in the
initial transformation matrix, and the separate origin, scale, and
rotation settings have their identity values.}
  然后，图形上下文的转换在初始转换矩阵中表示，单独的原点、比例和旋转设置具有它们的标识值。

}

@defmethod[(scale [x-scale real?]
                  [y-scale real?])
           void?]{

@;{Adds a scaling of @racket[x-scale] in the X-direction and
@racket[y-scale] in the Y-direction to the drawing context's current
transformation.}
  将X方向的@racket[x-scale]和Y方向的@racket[y-scale]添加到图形上下文的当前转换中。

@;{Afterward, the drawing context's transformation is represented in the
initial transformation matrix, and the separate origin, scale, and
rotation settings have their identity values.}
  然后，图形上下文的转换在初始转换矩阵中表示，单独的原点、比例和旋转设置具有它们的标识值。

}

@defmethod[(set-alignment-scale [scale (>/c 0.0)])
           void?]{

@;{Sets the drawing context's @deftech{alignment scale}, which determines
 how drawing coordinates and pen widths are adjusted for unsmoothed or
 aligned drawing (see @method[dc<%> set-smoothing]).}
  设置图形上下文的@deftech{对齐比例}，该比例决定如何为未平滑或对齐的图形调整图形坐标和笔宽（请参见@method[dc<%> set-smoothing]）。

@;{The default @tech{alignment scale} is @racket[1.0], which means that
 drawing coordinates and pen sizes are aligned to integer values.}
  默认的@tech{对齐比例}为1.0，这意味着图形坐标和笔大小与整数值对齐。

@;{An @tech{alignment scale} of @racket[2.0] aligns drawing coordinates
 to half-integer values. A value of @racket[2.0] could be suitable for
 a @racket[bitmap-dc%] whose destination is a bitmap with a
 @tech{backing scale} of @racket[2.0], since half-integer values
 correspond to pixel boundaries. Even when a destinate context has a
 backing scale of @racket[2.0], however, an alignment scale of
 @racket[1.0] may be desirable to maintain consistency with drawing
 contexts that have a backing scale and alignment scale of
 @racket[1.0].}
  @racket[2.0]的@tech{对齐比例}将图形坐标与半整数值对齐。@racket[2.0]的值可能适用于目标是@tech{支持比例（backing scale）}为@racket[2.0]的位图的@racket[bitmap-dc%]，因为半整数值对应于像素边界。然而，即使目标上下文的支持比例为@racket[2.0]，也可能需要@racket[1.0]的对齐比例来保持与支持比例和对齐比例为@racket[1.0]的图形上下文的一致性。

@history[#:added "1.1"]}


@defmethod[(set-alpha [opacity (real-in 0 1)])
           void?]{

@;{Determines the opacity of drawing. A value of @racket[0.0] corresponds
to completely transparent (i.e., invisible) drawing, and @racket[1.0]
corresponds to completely opaque drawing. For intermediate values,
drawing is blended with the existing content of the drawing context.
A color (e.g. for a brush) also has an alpha value; it is combined
with the drawing context's alpha by multiplying.}
 确定绘图的不透明度。值@racket[0.0]对应于完全透明（即不可见）的绘图，@racket[1.0]对应于完全不透明的绘图。对于中间值，图形与图形上下文的现有内容混合。颜色（例如，用于画笔）也具有alpha值；它通过乘以与绘图上下文的alpha相结合。}


@defmethod*[([(set-background [color (is-a?/c color%)])
              void?]
             [(set-background [color-name string?])
              void?])]{

@;{Sets the background color for drawing in this object (e.g., using
@method[dc<%> clear] or using a stippled @racket[brush%] with the mode
@racket['opaque]). For monochrome drawing, all non-black colors are
treated as white.}
  设置此对象中绘图的背景色（例如，使用@method[dc<%> clear]或使用@racket['opaque]模式的点画@racket[brush%]）。对于单色绘图，所有非黑色的颜色都被视为白色。

}

@defmethod*[([(set-brush [brush (is-a?/c brush%)])
              void?]
             [(set-brush [color (is-a?/c color%)]
                         [style (or/c 'transparent 'solid 'opaque 
                                      'xor 'hilite 'panel 
                                      'bdiagonal-hatch 'crossdiag-hatch
                                      'fdiagonal-hatch 'cross-hatch 
                                      'horizontal-hatch 'vertical-hatch)])
              void?]
             [(set-brush [color-name string?]
                         [style (or/c 'transparent 'solid 'opaque 
                                      'xor 'hilite 'panel
                                      'bdiagonal-hatch 'crossdiag-hatch
                                      'fdiagonal-hatch 'cross-hatch
                                      'horizontal-hatch 'vertical-hatch)])
              void?])]{

@;{Sets the current brush for drawing in this object.  While a brush is
 selected into a drawing context, it cannot be modified. When a color
 and style are given, the arguments are as for @xmethod[brush-list%
 find-or-create-brush].}
  设置用于在此对象中绘制的当前画笔。在绘图上下文中选择一个画笔时，不能修改它。当给定颜色和样式时，参数是关于@xmethod[brush-list%
 find-or-create-brush]的。

}


@defmethod[(set-clipping-rect [x real?]
                              [y real?]
                              [width (and/c real? (not/c negative?))]
                              [height (and/c real? (not/c negative?))])
           void?]{

@;{Sets the clipping region to a rectangular region.}
  将剪切区域设置为矩形区域。

@;{See also @method[dc<%> set-clipping-region] and @method[dc<%>
get-clipping-region].}
另请参见@method[dc<%> set-clipping-region]和@method[dc<%>
get-clipping-region]。
  
@|DrawSizeNote|

}

@defmethod[(set-clipping-region [rgn (or/c (is-a?/c region%) #f)])
           void?]{

@;{Sets the clipping region for the drawing area, turning off all
 clipping within the drawing region if @racket[#f] is provided.}
  设置绘图区域的剪切区域，如果提供了@racket[#f]，则关闭绘图区域内的所有剪切。

@;{The clipping region must be reset after changing a @racket[dc<%>]
 object's origin or scale (unless it is @racket[#f]); see
 @racket[region%] for more information.}
  更改@racket[dc<%>]对象的原点或比例（除非它是@racket[#f]）后，必须重置剪裁区域；有关详细信息，请参阅@racket[region%]。

@;{See also @method[dc<%> set-clipping-rect] and @method[dc<%>
 get-clipping-region].}
  参见 @method[dc<%> set-clipping-rect]和@method[dc<%>
 get-clipping-region]。
  

}

@defmethod[(set-font [font (is-a?/c font%)])
           void?]{

@;{Sets the current font for drawing text in this object.}
  设置此对象中绘图文本的当前字体。

}

@defmethod[(set-initial-matrix [m (vector/c real? real? real? real? real? real?)])
           void?]{

@;{Set a transformation matrix that converts logical coordinates to
 device coordinates. The matrix applies before additional origin
 offset, scaling, and rotation.}
  设置将逻辑坐标转换为设备坐标的转换矩阵。该矩阵在附加原点偏移、缩放和旋转之前应用。

@;{See @method[dc<%> get-initial-matrix] for information on the matrix as
 represented by a vector @racket[m].}
  参见@method[dc<%> get-initial-matrix]了解向量@racket[m]表示的矩阵信息。

@;{See also @method[dc<%> transform], which adds a transformation to the
 current transformation, instead of changing the transformation
 composition in the middle.}
  请参见@method[dc<%> transform]，它将转换添加到当前转换，而不是在中间更改转换构图。

@|DrawSizeNote|

}

@defmethod[(set-origin [x real?]
                       [y real?])
           void?]{

@;{Sets the device origin, i.e., the location in device coordinates of
 @math{(0,0)} in logical coordinates. The origin offset applies after
 the initial transformation matrix, but before scaling and rotation.}
  设置设备原点，即逻辑坐标中的@math{(0,0)}在设备坐标中的位置。原点偏移应用于初始变换矩阵之后，但在缩放和旋转之前。

@;{See also @method[dc<%> translate], which adds a translation to the
 current transformation, instead of changing the transformation
 composition in the middle.}
  请参见@method[dc<%> translate]，它将转换添加到当前转换，而不是在中间更改转换构图。

@|DrawSizeNote|

}

@defmethod*[([(set-pen [pen (is-a?/c pen%)])
              void?]
             [(set-pen [color (is-a?/c color%)]
                       [width (real-in 0 255)]
                       [style (or/c 'transparent 'solid 'xor 'hilite
                                    'dot 'long-dash 'short-dash 'dot-dash 
                                    'xor-dot 'xor-long-dash 'xor-short-dash 
                                    'xor-dot-dash)])
              void?]
             [(set-pen [color-name string?]
                       [width (real-in 0 255)]
                       [style (or/c 'transparent 'solid 'xor 'hilite 
                                    'dot 'long-dash 'short-dash 'dot-dash 
                                    'xor-dot 'xor-long-dash 'xor-short-dash 
                                    'xor-dot-dash)])
              void?])]{

@;{Sets the current pen for this object. When a color, width, and style
 are given, the arguments are as for @xmethod[pen-list%
 find-or-create-pen].}
  设置此对象的当前笔。当给定颜色、宽度和样式时，参数与@xmethod[pen-list%
 find-or-create-pen]相同。

@;{The current pen does not affect text drawing; see also @method[dc<%>
 set-text-foreground].}
  当前笔不影响文本绘制；另请参见@method[dc<%>
 set-text-foreground]。

@;{While a pen is selected into a drawing context, it cannot be modified.}
  在绘图上下文中选择一个笔时，不能修改它。

}

@defmethod[(set-rotation [angle real?]) void?]{

@;{Set the rotation of logical coordinates in radians to device
coordinates. Rotation applies after the initial transformation matrix,
origin offset, and scaling.}
将以弧度表示的逻辑坐标旋转设置为设备坐标。旋转应用于初始变换矩阵、原点偏移和缩放之后。

@;{See also @method[dc<%> rotate], which adds a rotation to the current
 transformation, instead of changing the transformation composition.}
另请参见@method[dc<%> rotate]，它将旋转添加到当前转换，而不是更改转换组合。

@|DrawSizeNote|

}

@defmethod[(set-scale [x-scale real?]
                      [y-scale real?])
           void?]{

@;{Sets a scaling factor that maps logical coordinates to device
 coordinates.  Scaling applies after the initial transformation matrix
 and origin offset, but before rotation. Negative scaling factors have
 the effect of flipping.}
设置将逻辑坐标映射到设备坐标的比例因子。缩放应用于初始变换矩阵和原点偏移之后，但在旋转之前。负比例因子具有翻转效果。
  
@;{See also @method[dc<%> scale], which adds a scale to the current
 transformation, instead of changing the transformation composition in
 the middle.}
 也可以参见@method[dc<%> scale]，它增加了当前转换的比例，而不是改变中间的变换成分。 

@|DrawSizeNote|

}

@defmethod[(set-smoothing [mode (or/c 'unsmoothed 'smoothed 'aligned)])
           void?]{

@;{Enables or disables anti-aliased smoothing for drawing. (Text
 smoothing is not affected by this method, and is instead controlled
 through the @racket[font%] object.)}
  为绘图启用或禁用抗锯齿平滑。（文本平滑不受此方法的影响，而是通过@racket[font%]对象进行控制。）

@;{The smoothing mode is either @racket['unsmoothed], @racket['smoothed],
 or @racket['aligned]. Both @racket['aligned] and @racket['smoothed]
 are smoothing modes that enable anti-aliasing, while both
 @racket['unsmoothed] and @racket['aligned] adjust drawing coordinates
 to match pixel boundaries. For most applications that draw to the
 screen or bitmaps, @racket['aligned] mode is the best choice.}
平滑模式可以是@racket['unsmoothed]、@racket['smoothed]或@racket['aligned]。@racket['aligned]和@racket['smoothed]都是启用抗锯齿的平滑模式，而 @racket['unsmoothed]和@racket['aligned]都会调整绘图坐标以匹配像素边界。对于大多数绘制到屏幕或位图的应用程序来说，@racket['aligned]是最佳选择。

@;{Conceptually, integer drawing coordinates correspond to the boundary
 between pixels, and pen-based drawing is centered over a given line
 or curve. Thus, drawing with pen width @racket[1] from @math{(0, 10)}
 to @math{(10, 10)} in @racket['smoothed] mode draws a 2-pixel wide
 line with @math{50%} opacity.}
  从概念上讲，整数绘图坐标对应于像素之间的边界，基于笔的绘图在给定的直线或曲线上居中。因此，在@racket['smoothed]模式下，使用笔宽@racket[1]从@math{(0, 10)}到@math{(10, 10)}绘制2像素宽的线条，不透明度为@math{50%}。

@;{In @racket['unsmoothed] and @racket['aligned] modes, drawing
 coordinates are truncated based on the @tech{alignment scale} of the
 drawing context. Specifically, when the alignment scale is 1.0,
 drawing coordinates are truncated to integer coordinates. More
 generally, drawing coordinates are shifted toward zero so that the
 result multipled by the @tech{alignment scale} is integral. For line
 drawing, coordinates are further shifted based on the pen width and
 the alignment scale, where the shift corrsponds to half of the pen
 width (reduced to a value such that its multiplication times the
 alignment scale times two produces an integer). In addition, for pen
 drawing through @method[dc<%> draw-rectangle], @method[dc<%>
 draw-ellipse], @method[dc<%> draw-rounded-rectangle], and
 @method[dc<%> draw-arc], the given width and height are each
 decreased by @math{1.0} divided by the @tech{alignment scale}.}
 在@racket['unsmoothed]和@racket['aligned]模式中，图形坐标根据图形上下文的@tech{对齐比例（alignment scale）}被截断。具体来说，当对齐比例为1.0时，图形坐标将被截断为整数坐标。更一般地说，绘图坐标移向零，这样结果乘以@tech{对齐比例}就成了积分。对于线条绘制，坐标将根据笔宽和对齐比例进一步移动，其中移动对应于笔宽的一半（减少到一个值，使其乘以对齐比例乘以2产生一个整数）。此外，对于通过@method[dc<%> draw-rectangle]、@method[dc<%>
 draw-ellipse]、@method[dc<%> draw-rounded-rectangle]和 @method[dc<%> draw-arc]绘制的笔，给定的宽度和高度均除以对齐比例后减小@math{1.0}。}


@defmethod*[([(set-text-background [color (is-a?/c color%)])
              void?]
             [(set-text-background [color-name string?])
              void?])]{

@;{Sets the current text background color for this object. The text
 background color is painted behind text that is drawn with
 @method[dc<%> draw-text], but only for the @racket['solid] text mode
 (see @method[dc<%> set-text-mode]).}
  设置此对象的当前文本背景色。文本背景色绘制在使用@method[dc<%> draw-text]绘制的文本后面，但仅适用于 @racket['solid]文本模式（请参见@method[dc<%> set-text-mode]）。

@;{For monochrome drawing, all non-white colors are treated as black.}
  对于单色绘图，所有非白色的颜色都被视为黑色。

}

@defmethod*[([(set-text-foreground [color (is-a?/c color%)])
              void?]
             [(set-text-foreground [color-name string?])
              void?])]{

@;{Sets the current text foreground color for this object, used for
 drawing text with
@method[dc<%> draw-text].}
  设置此对象的当前文本前景色，用于绘制带@method[dc<%> draw-text]的文本。

@;{For monochrome drawing, all non-black colors are treated as
 white.}
  对于单色绘图，所有非黑色的颜色都被视为白色。

}

@defmethod[(set-text-mode [mode (or/c 'solid 'transparent)])
           void?]{

@;{Determines how text is drawn:}
  确定文本的绘制方式：

@itemize[

 @item{@racket['solid] @;{--- Before text is drawn, the destination area
       is filled with the text background color (see @method[dc<%>
       set-text-background]).}——在绘制文本之前，目标区域将填充文本背景色（请参见@method[dc<%>
       set-text-background]）。}

 @item{@racket['transparent] @;{--- Text is drawn directly over any
       existing image in the destination, as if overlaying text
       written on transparent film.}——文本直接绘制在目标中的任何现有图像上，就像覆盖在透明胶片上的文本一样。}

]

}


@defmethod[(set-transformation
            [t (vector/c (vector/c real? real? real? real? real? real?)
                         real? real? real? real? real?)])
           void?]{

@;{Sets the draw context's transformation. See @method[dc<%>
get-transformation] for information about @racket[t].}
 设置绘图上下文的转换。有关@racket[t]的信息，请参见@method[dc<%>
get-transformation]。}


@defmethod[(start-doc [message string?])
           void?]{

@;{Starts a document, relevant only when drawing to a printer,
 PostScript, PDF, or SVG device.  For some
 platforms, the @racket[message] string is displayed in a dialog until
 @method[dc<%> end-doc] is called.}
  仅在绘制到打印机、PostScript、PDF或SVG设备关联时启动文档。对于某些平台，@racket[message]字符串将显示在对话框中，直到调用@method[dc<%> end-doc]。

@;{For relevant devices, an exception is raised if
 @method[dc<%> start-doc] has been called already (even if @method[dc<%>
 end-doc] has been called as well). Furthermore, drawing methods raise
 an exception if not called while a page is active as determined by
 @method[dc<%> start-doc] and @method[dc<%> start-page].}
对于相关设备，如果已经调用了@method[dc<%> start-doc]（即使也调用了@method[dc<%>
 end-doc]），则会引发异常。此外，绘图方法在页面处于活动状态时（由@method[dc<%> start-doc]和@method[dc<%> start-page]确定）如果不调用，则会引发异常。

}

@defmethod[(start-page)
           void?]{

@;{Starts a page, relevant only when drawing to a printer, PostScript,
 SVG, or PDF device.}
启动一个页面，仅当绘图到打印机、PostScript、SVG或PDF设备时才相关。

@;{Relevant devices, an exception is raised if
 @method[dc<%> start-page] is called when a page is already started, or when
 @method[dc<%> start-doc] has not been called, or when @method[dc<%>
 end-doc] has been called already. In addition, in the case of
 PostScript output, Encapsulated PostScript (EPS) cannot contain
 multiple pages, so calling @racket[start-page] a second time for a
 @racket[post-script-dc%] instance raises an exception; to create
 PostScript output with multiple pages, supply @racket[#f] as the
 @racket[as-eps] initialization argument for @racket[post-script-dc%].}
关联设备，如果在已启动页、或未调用@method[dc<%> start-doc]或已调用@method[dc<%>
 end-doc]时调用@method[dc<%> start-page]，则会引发异常。此外，在PostScript输出的情况下，封装PostScript（EPS）不能包含多个页面，因此对@racket[post-script-dc%]实例再次调用@racket[start-page]会引发异常；要创建多个页面的PostScript输出，请提供@racket[#f]作为@racket[post-script-dc%]的@racket[as-eps]初始化参数。
}


@defmethod[(suspend-flush) void?]{

@;{Calls the @xmethod[canvas<%> suspend-flush] method for
@racket[canvas<%>] output, and has no effect for other kinds of
drawing contexts.}
 调用@racket[canvas<%>]输出的@xmethod[canvas<%> suspend-flush]方法，对其它类型的绘图上下文无效。}


@defmethod[(transform [m (vector/c real? real? real? real? real? real?)])
           void?]{

@;{Adds a transformation by @racket[m] to the drawing context's current
transformation. }
将 @racket[m]转换添加到绘图上下文的当前转换中。

@;{See @method[dc<%> get-initial-matrix] for information on the matrix as
 represented by a vector @racket[m].}
有关用向量@racket[m]表示的矩阵的信息，请参见@method[dc<%> get-initial-matrix]。

@;{Afterward, the drawing context's transformation is represented in the
initial transformation matrix, and the separate origin, scale, and
rotation settings have their identity values.}
然后，图形上下文的转换在初始转换矩阵中表示，单独的原点、比例和旋转设置具有它们的标识值。
}

@defmethod[(translate [dx real?]
                      [dy real?])
           void?]{

@;{Adds a translation of @racket[dx] in the X-direction and @racket[dy] in
the Y-direction to the drawing context's current transformation.}
将X方向的@racket[dx]和Y方向的@racket[dy]的转换添加到绘图上下文的当前转换中。
  
@;{Afterward, the drawing context's transformation is represented in the
initial transformation matrix, and the separate origin, scale, and
rotation settings have their identity values.}
 然后，图形上下文的转换在初始转换矩阵中表示，单独的原点、比例和旋转设置具有它们的标识值。 

}


@defmethod[(try-color [try (is-a?/c color%)]
                      [result (is-a?/c color%)])
           void?]{

@;{Determines the actual color used for drawing requests with the given
 color. The @racket[result] color is set to the RGB values that are
 actually produced for this drawing context to draw the color
 @racket[try].}
  确定用于绘制具有给定颜色的请求的实际颜色。@racket[result]颜色设置为实际为此绘图上下文生成的RGB值，以绘制颜色@racket[try]。

}}
