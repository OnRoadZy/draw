#lang scribble/doc
@(require "common.rkt")

@defclass/title[dc-path% object% ()]{

@;{A path is a set of figures defined by curves. A path can be used with
the @method[dc<%> draw-path] method of a @racket[dc<%>] object to draw
the path's curves as lines, fill the region bounded by the path's
curves, or both. A path can also be used with the @method[region%
set-path] method of a @racket[region%] object to generate a region
bounded by the path's curves.}
路径是由曲线定义的一组图形。路径可以与@racket[dc<%>]对象的@method[dc<%> draw-path]方法一起使用，以将路径的曲线绘制为直线、填充由路径曲线界定的区域，或者两者都使用。路径还可以与@racket[region%]对象的@method[region%
set-path]方法一起使用，以生成由路径曲线限定的区域。

@;{A path consists of zero or more @deftech{closed sub-paths}, and
 possibly one @deftech{open sub-path}. Some @racket[dc-path%] methods
 extend the open sub-path, some @racket[dc-path%] methods close the
 open sub-path, and some @racket[dc-path%] methods add closed
 sub-paths. This approach to drawing formulation is inherited from
 PostScript @cite["Adobe99"].}
一个路径包含零个或多个@deftech{闭合子路径（closed sub-paths）}，可能还有一个开放子路径。某些@racket[dc-path%]方法扩展了@deftech{开放子路径（open sub-path）}，某些@racket[dc-path%]方法关闭打开的子路径，而某些@racket[dc-path%]方法添加了关闭的子路径。这种绘制公式的方法继承自PostScript@cite["Adobe99"]。

@;{When a path is drawn as a line, a closed sub-path is drawn as a closed
 figure, analogous to a polygon. An open sub-path is drawn with
 disjoint start and end points, analogous lines drawn with
 @xmethod[dc<%> draw-lines].}
当一条路径被画成一条线时，一条封闭的子路径被画成一个封闭的图形，类似于一个多边形。打开的子路径以不相交的起点和终点绘制，类似的线以@xmethod[dc<%> draw-lines]绘制。

@;{When a path is filled or used as a region, the open sub-path (if any)
 is treated as if it were closed. The content of a path is determined
 either through the @racket['even-odd] rule or the @racket['winding]
 rule, as selected at the time when the path is filled or used to
 generate a region.}
当路径被填充或用作区域时，打开的子路径（如果有）将被视为已关闭。路径的内容可以通过@racket['even-odd]或@racket['winding]来确定，该规则是在路径被填充或用于生成区域时选择的。

@;{A path is not connected to any particular @racket[dc<%>] object, so
 setting a @racket[dc<%>] origin or scale does not affect path
 operations. Instead, a @racket[dc<%>]'s origin and scale apply at the
 time that the path is drawn or used to set a region.}
路径没有连接到任何特定的@racket[dc<%>]对象，因此设置@racket[dc<%>]原点或比例不会影响路径操作。相反，@racket[dc<%>]的原点和比例在绘制路径或用于设置区域时使用。

@defconstructor[()]{

@;{Creates a new path that contains no sub-paths (and no @tech{open
sub-path}).}
创建不包含子路径（也不包含@tech{开放子路径（open
sub-path）}）的新路径。
}


@defmethod[(append [path (is-a?/c dc-path%)])
           void?]{

@;{Adds the sub-paths of @racket[path] to @this-obj[]. @tech{Closed
 sub-paths} of @racket[path] are added as @tech{closed sub-paths} to
 @this-obj[]. If both paths have an @tech{open sub-path}, then this
 path's sub-path is extended by the given path's @tech{open sub-path},
 adding a line from this path's current ending point to the given
 path's starting point. If only one of the paths has an @tech{open
 sub-path}, then it becomes (or remains) this path's @tech{open
 sub-path}.}
将@racket[path]的子路径添加到@this-obj[]。@racket[path]的@tech{闭合子路径（Closed
 sub-paths）}作为@tech{闭合子路径}添加到@this-obj[]。如果两个路径都有一个@tech{开放子路径}，则此路径的子路径将由给定路径的开放子路径扩展，并将一条线从该路径的当前终结点添加到给定路径的起始点。如果只有一条路径具有@tech{开放子路径}，则它将成为（或保持）此路径的@tech{开放子路径}。
}

@defmethod[(arc [x real?]
                [y real?]
                [width real?]
                [height real?]
                [start-radians real?]
                [end-radians real?]
                [counter-clockwise? any/c #t])
           void?]{

@;{Extends or starts the path's @tech{open sub-path} with a curve that
 corresponds to a section of an ellipse. If @racket[width] and @racket[height]
 are non-negative, the ellipse is the one
 bounded by a rectangle whose top-left corner is @math{(@racket[x],
 @racket[y])} and whose dimensions are @racket[width] by
 @racket[height]; if @racket[width] is negative, then
 the rectangle's right edge is @racket[x], and the ellipse
 width is @racket[(abs width)], while a negative @racket[height]
 similarly makes @racket[y] is the bottom edge of the ellipse and
 the height @racket[(abs height)].
 @margin-note*{Support for negative @racket[width] and @racket[height]
 helps avoid round-off problems for aligned drawing in an eventual 
 destination, since @method[dc-path% arc] reduces its input to a sequence of curves.
 In contrast, @xmethod[dc<%> draw-arc] can automatically correct for round off,
 since the drawing mode is known immediately.}
 The ellipse section starts at the angle
 @racket[start-radians] (@racket[0] is three o'clock and half-π is
 twelve o'clock) and continues to the angle @racket[end-radians]; if
 @racket[counter-clockwise?] is true, then the arc runs
 counter-clockwise from @racket[start-radians] to
 @racket[end-radians], otherwise it runs clockwise.}
用与椭圆截面相对应的曲线扩展或启动路径的@tech{开放子路径}。如果@racket[width]和@racket[height]非负，则椭圆是由左上角为@math{(@racket[x],
 @racket[y])}且尺寸以高度为宽度的矩形限定的；如果@racket[width]为负，则矩形的右边缘为@racket[x]，椭圆宽度为@racket[(abs width)]，而负@racket[height]同样使@racket[y]是椭圆的下边缘并且高度是@racket[(abs width)]。@margin-note*{对负@racket[width]和@racket[height]的支持有助于避免最终目标中对齐绘图的舍入问题，因为@method[dc-path% arc]将其输入减少到一系列曲线。相比之下，@xmethod[dc<%> draw-arc]可以自动校正舍入。因为绘图模式是立即知道的。}椭圆部分以角@racket[start-radians]（@racket[0]是三点钟，半π是12点钟）开始，并继续到角@racket[end-radians]；如果@racket[counter-clockwise?]为真，则弧从@racket[start-radians]到@racket[end-radians]为逆时针方向，否则为顺时针方向。
             
@;{If the path has no @tech{open sub-path}, a new one is started with the
 arc's starting point. Otherwise, the arc extends the existing
 sub-path, and the existing path is connected with a line to the arc's
 starting point.}
如果路径没有@tech{开放子路径}，则新的子路径将从弧的起点开始。否则，圆弧会延伸现有的子路径，并且现有路径与到圆弧起点的直线连接。
}

@defmethod[(close)
           void?]{

@;{Closes the path's @tech{open sub-path}. If the path has no @tech{open
 sub-path}, @|MismatchExn|.}
关闭路径的@tech{开放子路径}。如果路径没有@tech{开放子路径}，@|MismatchExn|。
}

@defmethod[(curve-to [x1 real?]
                     [y1 real?]
                     [x2 real?]
                     [y2 real?]
                     [x3 real?]
                     [y3 real?])
           void?]{

@;{Extends the path's @tech{open sub-path} with a Bezier curve to the
 given point @math{(@racket[x3],@racket[y3])}, using the points
 @math{(@racket[x1], @racket[y1])} and @math{(@racket[x2],
 @racket[y2])} as control points. If the path has no @tech{open
 sub-path}, @|MismatchExn|.}
使用点@math{(@racket[x1],@racket[y1])}和@math{(@racket[x2],@racket[y2])}作为控制点，使用贝塞尔曲线将路径的@tech{开放子路径}扩展到给定点@math{(@racket[x3],@racket[y3])}。如果路径没有@tech{开放子路径}，@|MismatchExn|。
}

@defmethod[(ellipse [x real?]
                    [y real?]
                    [width (and/c real? (not/c negative?))]
                    [height (and/c real? (not/c negative?))])
           void?]{

@;{Closes the @tech{open sub-path}, if any, and adds a @tech{closed
 sub-path} that represents an ellipse bounded by a rectangle whose
 top-left corner is @math{(@racket[x], @racket[y])} and whose
 dimensions are @racket[width] by @racket[height]. (This convenience
 method is implemented in terms of @method[dc-path% close] and
 @method[dc-path% arc].)}
关闭@tech{开放子路径}，如果有，并添加一个@tech{闭合子路径}，该子路径表示一个椭圆，该椭圆由一个左上角为@math{(@racket[x], @racket[y])}且尺寸为@racket[width]乘以@racket[height]。（这种方便的方法是通过@method[dc-path% close]和@method[dc-path% arc]来实现的。）
}

@defmethod[(get-bounding-box)
           (values real? real? real? real?)]{

@;{Returns a rectangle that encloses the path's points.  The return
 values are the left, top, width, and height of the rectangle.}
返回一个包含路径点的矩形。返回值是矩形的左侧、顶部、宽度和高度。

@;{For curves within the path, the bounding box enclosed the two control
 points as well as the start and end points. Thus, the bounding box
 does not always tightly bound the path.}
对于路径中的曲线，边界框封闭了两个控制点以及起点和终点。因此，边界框并不总是紧密地绑定路径。
}


@defmethod[(get-datum) (values (listof (listof vector?)) (listof vector?))]{

@;{Returns a representation of the path as lists of vectors. The first
result is a list that contains a list for each @tech{closed sub-path},
and the second result is a list for the @tech{open sub-path}. The
second result is the empty list if the path has no @tech{open
sub-path}.}
返回路径的矢量列表表示形式。第一个结果是一个列表，其中包含每个@tech{闭合子路径}的列表，第二个结果是@tech{开放子路径}的列表。如果路径没有@tech{开放子路径}，则第二个结果是空列表。

@;{Each list representing a sub-path starts with a vector of two numbers
that represent the starting point for the path. Each subsequent
element is either a vector of two numbers, which represents a line
connecting the previous point to the new one, or a vector of six
numbers, which represents a curve connecting the previous point to a
new point; in the latter case, the fifth and six numbers in the vector
represent the ending point of the curve, the first and second numbers
represent the first control point of the curve, and the third and
fourth numbers represent the second control point of the curve.}
表示子路径的每个列表都以表示路径起点的两个数字的向量开始。后面的每个元素要么是两个数字的矢量，表示一条将前一个点连接到新点的线，要么是六个数字的矢量，表示一条将前一个点连接到新点的曲线；在后一种情况下，矢量中的第五个和六个数字表示曲线的终点，第一个和第二个数字表示曲线的第一个控制点，第三个和第四个数字表示曲线的第二个控制点。

@history[#:added "1.8"]}


@defmethod[(line-to [x real?]
                    [y real?])
           void?]{

@;{Extends the path's @tech{open sub-path} with a line to the given
 point. If the path has no @tech{open sub-path}, @|MismatchExn|.}
用一条线将路径的@tech{开放子路径}扩展到给定点。如果路径没有@tech{开放子路径}，@|MismatchExn|。
}

@defmethod[(lines [points (or/c (listof (is-a?/c point%))
                                (listof (cons/c real? real?)))]
                  [xoffset real? 0]
                  [yoffset real? 0])
           void?]{

@;{Extends the path's @tech{open sub-path} with a sequences of lines to
 the given points. A pair is treated as a point where the @racket[car]
 of the pair is the x-value and the @racket[cdr] is the y-value.
 If the path has no @tech{open sub-path},
 @|MismatchExn|.  (This convenience method is implemented in terms of
 @method[dc-path% line-to].)}
用一系列线将路径的@tech{开放子路径}扩展到给定点。一配对被视为一个点，其中配对的@racket[car]是x值，@racket[cdr]是y值。如果路径没有@tech{开放子路径}，@|MismatchExn|。（此方便方法是根据@method[dc-path% line-to]实现的。）
}

@defmethod[(move-to [x real?]
                    [y real?])
           void?]{

@;{After closing the @tech{open sub-path}, if any, starts a new
 @tech{open sub-path} with the given initial point.}
 关闭@tech{开放子路径}（如果有）后，将使用给定的初始点启动新的@tech{开放子路径}。
 }


@defmethod[(open?)
           boolean?]{

@;{Returns @racket[#t] if the path has an @tech{open sub-path},
@racket[#f] otherwise.}
如果路径有@tech{开放子路径}，则返回@racket[#t]，否则返回@racket[#f]。
 }


@defmethod[(rectangle [x real?]
                      [y real?]
                      [width (and/c real? (not/c negative?))]
                      [height (and/c real? (not/c negative?))])
           void?]{

@;{Closes the @tech{open sub-path}, if any, and adds a closed path that
 represents a rectangle whose top-left corner is @math{(@racket[x],
 @racket[y])} and whose dimensions are @racket[width] by
 @racket[height]. (This convenience method is implemented in terms of
 @method[dc-path% close], @method[dc-path% move-to], and
 @method[dc-path% line-to].)}
关闭@tech{开放子路径}（如果有），并添加一个表示左上角为@math{(@racket[x],@racket[y])}且尺寸为@racket[width]乘以@racket[height]的矩形的闭合路径。（此方便方法是根据@method[dc-path% close]、@method[dc-path% move-to]和@method[dc-path% line-to]实现的。）
 }


@defmethod[(reset)
           void?]{

@;{Removes all sub-paths of the path.}
删除路径的所有子路径。
 }


@defmethod[(reverse)
           void?]{

@;{Reverses the order of all points in all sub-paths. If the path has an
 @tech{open sub-path}, the starting point becomes the ending point,
 and extensions to the @tech{open sub-path} build on this new ending
 point. Reversing a @tech{closed sub-path} affects how it combines
 with other sub-paths when determining the content of a path in
 @racket['winding] mode.}
反转所有子路径中所有点的顺序。如果路径具有@tech{开放子路径}，则起始点将成为终结点，并且对@tech{开放子路径}的扩展将在此新的终结点上构建。当确定@racket['winding]模式下路径的内容时，反转@tech{闭合子路径}会影响它与其他子路径的组合方式。
 }


@defmethod[(rotate [radians real?])
           void?]{

@;{Adjusts all points within the path (including all sub-paths), rotating
 them @racket[radians] counter-clockwise around @math{(0, 0)}. Future
 additions to the path are not rotated by this call.}
调整路径中的所有点（包括所有子路径），围绕@math{(0,0)}逆时针旋转@racket[radians]弧度。此调用不会旋转将来添加到路径的内容。
 }


@defmethod[(rounded-rectangle [x real?]
                              [y real?]
                              [width (and/c real? (not/c negative?))]
                              [height (and/c real? (not/c negative?))]
                              [radius real? -0.25])
           void?]{

@;{Closes the @tech{open sub-path}, if any, and adds a @tech{closed
 sub-path} that represents a round-cornered rectangle whose top-left
 corner is @math{(@racket[x] @racket[y])} and whose dimensions are
 @racket[width] by @racket[height]. (This convenience method is
 implemented in terms of @method[dc-path% close], @method[dc-path%
 move-to], @method[dc-path% arc], and @method[dc-path% line-to].)}
关闭@tech{开放子路径}（如果有），并添加一个@tech{闭合子路径}，该子路径表示左上角为@math{(@racket[x] @racket[y])}且尺寸按@racket[width]乘以@racket[height]的圆角矩形。（这种方便的方法是在@method[dc-path% close]、@method[dc-path%
 move-to]、@method[dc-path% arc]和@method[dc-path% line-to]中实现的。）
         
@;{If @racket[radius] is positive, the value is used as the radius of the
 rounded corner. If @racket[radius] is negative, the absolute value is
 used as the @italic{proportion} of the smallest dimension of the
 rectangle.}
如果@racket[radius]为正数，则该值将用作圆角的半径。如果@racket[radius]为负，则使用绝对值作为矩形最小尺寸的@italic{比例}。

@;{If @racket[radius] is less than @racket[-0.5] or more than half of
 @racket[width] or @racket[height], @|MismatchExn|.}
如果@racket[radius]小于@racket[-0.5]或大于@racket[width]或@racket[height]的一半，@|MismatchExn|。
 }


@defmethod[(scale [x real?]
                  [y real?])
           void?]{

@;{@index['("paths" "flipping")]{Adjusts} all points within the path
 (including all sub-paths), multiplying each x-coordinate by
 @racket[x] and each y-coordinate by @racket[y]. Scaling by a negative
 number flips the path over the corresponding axis. Future additions
 to the path are not scaled by this call.}
@index['("paths" "flipping")]{调整}路径中的所有点（包括所有子路径），将每个X坐标乘以@racket[x]，每个Y坐标乘以@racket[y]。用负数缩放会翻转相应轴上的路径。将来添加到路径中的内容不会通过此调用进行缩放。
 }


@defmethod[(text-outline [font (is-a?/c font%)]
                         [str string?]
                         [x real?]
                         [y real?]
                         [combine? any/c #f])
           void?]{

@;{Closes the @tech{open sub-path}, if any, and adds a @tech{closed
 sub-path} to outline @racket[str] using @racket[font]. The
 top left of the text is positioned at @racket[x] and @racket[y]. The
 @racket[combine?] argument enables kerning and character combinations
 as for @xmethod[dc<%> draw-text].}
关闭@tech{开放子路径}（如果有），并使用@racket[font]将@tech{闭合子路径}添加到轮廓线@racket[str]。文本的左上角位于@racket[x]和@racket[y]处。@racket[combine?]参数启用紧排和字符组合，如同在@xmethod[dc<%> draw-text]一样。
 }


@defmethod[(transform [m (vector/c real? real? real? real? real? real?)])
           void?]{

@;{Adjusts all points within the path (including all sub-paths) by
applying the transformation represented by @racket[m].}
通过应用@racket[m]表示的转换调整路径中的所有点（包括所有子路径）。

@;{See @method[dc<%> get-initial-matrix] for information on the matrix as
 represented by a vector @racket[m].}
有关用向量@racket[m]表示的矩阵的信息，请参见@method[dc<%> get-initial-matrix]。
 }


@defmethod[(translate [x real?]
                      [y real?])
           void?]{

@;{Adjusts all points within the path (including all sub-paths), shifting
 then @racket[x] to the right and @racket[y] down.  Future additions
to the path are not translated by this call.}
调整路径中的所有点（包括所有子路径），然后向右移动@racket[x]，向下移动@racket[y]。此调用不会转换将来添加到路径的内容。
 }
}
