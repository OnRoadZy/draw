#lang scribble/doc
@(require "common.rkt")

@defclass/title[region% object% ()]{

@;{A @racket[region%] object specifies a portion of a drawing area
 (possibly discontinuous). It is normally used for clipping drawing
 operations.}
@racket[region%]对象指定绘图区域的一部分（可能不连续）。它通常用于剪切绘图操作。

@;{A @racket[region%] object can be associated to a particular
 @racket[dc<%>] object when the region is created. In that case, the
 region uses the drawing context's current transformation matrix,
 translation, scaling, and rotation, independent of the transformation
 that is in place when the region is installed. Otherwise, the region
 is transformed as usual when it is installed into a
 @racket[dc<%>]. For an auto-scrolled canvas, the canvas's current
 scrolling always applies when the region is used (and it does not
 affect the region's bounding box).}
  创建区域时，@racket[region%]对象可以与特定@racket[dc<%>]对象关联。在这种情况下，区域使用图形上下文的当前转换矩阵、平移、缩放和旋转，而不依赖于安装区域时的转换。否则，当区域安装到@racket[dc<%>]时，它会像往常一样进行转换。对于自动滚动的画布，当使用区域时，画布的当前滚动始终适用（并且不影响区域的边界框）。

@;{Region combination with operations like @method[region% union] are
 approximate, and they are implemented by combining paths. Certain
 combinations work only if the paths have a suitable fill mode, which
 can be either @racket['winding], @racket['even-odd], or a
 @deftech{flexible fill} mode. When a region is installed as a device
 context's clipping region, any subpath with a @tech{flexible fill}
 mode uses @racket['even-odd] mode if any other path uses
 @racket['even-odd] mode.}
  区域组合与@method[region% union]之类的操作是近似的，它们是通过组合路径实现的。某些组合仅在路径具有适当的填充模式，可以是@racket['winding]、@racket['even-odd]或
 @deftech{灵活填充（flexible fill）}模式）时才起作用。当一个区域安装为设备上下文的剪切区域时，如果任何其他路径使用@racket['even-odd]模式，任何具有@tech{灵活填充}模式的子路径都会使用@racket['even-odd]模式。

@;{See also @xmethod[dc<%> set-clipping-region] and @xmethod[dc<%>
 get-clipping-region].}
  另参见@xmethod[dc<%> set-clipping-region] and @xmethod[dc<%>
 get-clipping-region]。


@defconstructor[([dc (or/c (is-a?/c dc<%>) #f)])]{

@;{Creates an empty region. If @racket[dc] is a @racket[dc<%>] object,
the @racket[dc<%>]'s current transformation matrix is essentially
recorded in the region.}
  创建空区域。如果@racket[dc]是@racket[dc<%>]对象，则@racket[dc<%>]的当前变换矩阵基本上记录在该区域中。

}

@defmethod[(get-bounding-box)
           (values real? real? real? real?)]{

@;{Returns a rectangle that approximately encloses the region.  The
 return values are the left, top, width, and height of the
 rectangle. If the region has an associated drawing context, the
 bounding box is in the drawing context's current logical coordinates.}
  返回一个近似包围该区域的矩形。返回值是矩形的左侧、顶部、宽度和高度。如果区域具有关联的图形上下文，则边界框位于图形上下文的当前逻辑坐标中。
}

@defmethod[(get-dc)
           (or/c (is-a?/c dc<%>) #f)]{

@;{Returns the region's drawing context, if it was created for one.}
  如果是为该区域创建的，返回区域的绘图上下文。

}

@defmethod[(in-region? [x real?]
                       [y real?])
           boolean?]{

@;{Returns @racket[#t] if the given point is approximately within the
 region, @racket[#f] otherwise. If the region has an associated
 drawing context, the given point is effectively transformed according
 to the region's @racket[dc<%>]'s current transformation matrix.}
  如果给定点大约在区域内，则返回@racket[#t]，否则返回@racket[#f]。如果区域有关联的绘图上下文，则根据区域的@racket[dc<%>]的当前转换矩阵有效地转换给定点。

}

@defmethod[(intersect [rgn (is-a?/c region%)])
           void?]{

@;{Sets the region to the intersection of itself with the given region.}
  将区域设置为自身与给定区域的交集。

@;{The drawing context of @racket[rgn] and @this-obj[] must be the same,
 or they must both be unassociated to any drawing context.}
  @racket[rgn]和@this-obj[]的绘图上下文必须相同，或者两者都不能与任何绘图上下文关联。

@;{An intersect corresponds to clipping with this region's path, and then
 clipping with the given region's path.  Further combining sends to
 this region correspond to combination with the original path before
 initial clip, and further combination with this region as an argument
 correspond to a combination with the given path after the initial
 clip. Thus, an intersecting region is a poor input for
 @method[region% union], @method[region% subtract], or @method[region%
 xor], but it intersects properly in further calls to @method[region%
 intersect].}
  相交对应于用该区域的路径进行剪裁，然后用给定区域的路径进行剪裁。进一步组合发送到此区域对应于与初始剪辑之前的原始路径的组合，进一步组合此区域作为参数对应于与初始剪辑之后的给定路径的组合。因此，相交区域对于@method[region% union]、@method[region% subtract]或@method[region%
 xor]来说是一个糟糕的输入，但在进一步的相交调用中，它会正确相交。

}

@defmethod[(is-empty?)
           boolean?]{

@;{Returns @racket[#t] if the region is approximately empty, @racket[#f]
 otherwise, but only if the region is associated with a drawing context.
 If the region is unassociated to any drawing context, the
 @racket[exn:fail:contract] exception is raised.}
  如果区域约为空，则返回@racket[#t]，否则返回@racket[#f]，但仅当区域与图形上下文关联时返回。如果区域未与任何绘图上下文关联，则会引发@racket[exn:fail:contract]异常。

}

@defmethod[(set-arc [x real?]
                    [y real?]
                    [width (and/c real? (not/c negative?))]
                    [height (and/c real? (not/c negative?))]
                    [start-radians real?]
                    [end-radians real?])
           void?]{

@;{Sets the region to the interior of the specified wedge.}
  将区域设置为指定楔块的内部。

@;{See also @xmethod[dc<%> draw-ellipse], since the region content is
 determined the same way as brush-based filling in a @racket[dc<%>].}
  另请参见@xmethod[dc<%> draw-ellipse]，因为区域内容的确定方式与在@racket[dc<%>]中基于刷子的填充相同。

@;{The region corresponds to a clockwise path with a @tech{flexible
 fill}. The region is also @tech{atomic} for the purposes of region
 combination.}
  该区域对应于具有@tech{柔性填充（flexible
 fill）}的顺时针路径。为了区域组合的目的，区域也是@tech{原子（atomic）}的。

}

@defmethod[(set-ellipse [x real?]
                        [y real?]
                        [width (and/c real? (not/c negative?))]
                        [height (and/c real? (not/c negative?))])
           void?]{

@;{Sets the region to the interior of the specified ellipse.}
  将区域设置为指定椭圆的内部。

@;{See also @xmethod[dc<%> draw-ellipse], since the region content is
 determined the same way as brush-based filling in a @racket[dc<%>].}
  另请参见@xmethod[dc<%> draw-ellipse]，因为区域内容的确定方式与在@racket[dc<%>]中基于刷子的填充相同。

@;{The region corresponds to a clockwise path with a @tech{flexible
 fill}. The region is also @tech{atomic} for the purposes of region
 combination.}
  该区域对应于具有柔性填充的顺时针路径。为了区域组合的目的，区域也是@tech{原子（atomic）}的。

@|DrawSizeNote|

}

@defmethod[(set-path [path (is-a?/c dc-path%)]
                     [xoffset real? 0]
                     [yoffset real? 0]
                     [fill-style (or/c 'odd-even 'winding) 'odd-even])
           void?]{

@;{Sets the region to the content of the given path.}
将区域设置为给定路径的内容。

@;{See also @xmethod[dc<%> draw-path], since the region content is
 determined the same way as brush-based filling in a @racket[dc<%>].}
另请参见@xmethod[dc<%> draw-path]，因为区域内容的确定方式与在@racket[dc<%>]中基于刷子的填充相同。

@;{The fill style affects how well the region reliably combines with
 other regions (via @method[region% union], @method[region% xor], and
 @method[region% subtract]). The region is also @tech{atomic} for the
 purposes of region combination.}
  填充样式影响区域与其他区域（通过@method[region% union]、@method[region% xor]和@method[region% subtract]）可靠结合的程度。为了区域组合的目的，区域也是@tech{原子（atomic）}的。

}

@defmethod[(set-polygon [points (or/c (listof (is-a?/c point%))
                                      (listof (cons/c real? real?)))]
                        [xoffset real? 0]
                        [yoffset real? 0]
                        [fill-style (or/c 'odd-even 'winding) 'odd-even])
           void?]{

@;{Sets the region to the interior of the polygon specified by
 @racket[points]. A pair is treated as a point where the @racket[car]
 of the pair is the x-value and the @racket[cdr] is the y-value.}
将区域设置为由@racket[points]指定的多边形内部。一对被视为一个点，其中配对的@racket[car]是x值，@racket[cdr]是y值。

@;{See also @xmethod[dc<%> draw-polygon], since the region content is
 determined the same way as brush-based filling in a @racket[dc<%>].}
  另请参见@xmethod[dc<%> draw-polygon]，因为区域内容的确定方式与在@racket[dc<%>]中基于刷子的填充相同。

@;{The fill style affects how well the region reliably combines with
 other regions (via @method[region% union], @method[region% xor], and
 @method[region% subtract]).  The region is also @tech{atomic} for the
 purposes of region combination.}
  填充样式影响区域与其他区域（通过@method[region% union]、@method[region% xor]和@method[region% subtract]）可靠结合的程度。为了区域组合的目的，区域也是@tech{原子（atomic）}的。

}

@defmethod[(set-rectangle [x real?]
                          [y real?]
                          [width (and/c real? (not/c negative?))]
                          [height (and/c real? (not/c negative?))])
           void?]{

@;{Sets the region to the interior of the specified rectangle.}
  将区域设置为指定矩形的内部。

@;{The region corresponds to a clockwise path with a @tech{flexible
 fill}. The region is also @tech{atomic} for the purposes of region
 combination.}
  该区域对应于具有@tech{柔性填充（flexible
 fill）}的顺时针路径。为了区域组合的目的，区域也是@tech{原子（atomic）}的。

@|DrawSizeNote|

}

@defmethod[(set-rounded-rectangle [x real?]
                                  [y real?]
                                  [width (and/c real? (not/c negative?))]
                                  [height (and/c real? (not/c negative?))]
                                  [radius real? -0.25])
           void?]{

@;{Sets the region to the interior of the specified rounded rectangle.}
将区域设置为指定圆角矩形的内部。

@;{See also @xmethod[dc<%> draw-rounded-rectangle], since the region
 content is determined the same way as brush-based filling in a
 @racket[dc<%>].}
另请参见@xmethod[dc<%> draw-rounded-rectangle]，因为区域内容的确定方式与在@racket[dc<%>]中基于画笔的填充相同。

@;{The region corresponds to a clockwise path with a @tech{flexible
 fill}. The region is also @tech{atomic} for the purposes of region
 combination.}
该区域对应于具有柔性填充的顺时针路径。为了区域组合的目的，区域也是@tech{原子（atomic）}的。

@|DrawSizeNote|

}

@defmethod[(subtract [rgn (is-a?/c region%)])
           void?]{

@;{Sets the region to the subtraction of itself minus the given region.
 In other words, a point is removed from the region if it is included
 in the given region. (The given region may contain points that are
 not in the current region; such points are ignored.)}
将区域设置为自身减去给定区域的减法。换句话说，如果某个点包含在给定区域中，则该点将从该区域中删除。（给定区域可能包含不在当前区域中的点；这些点将被忽略。）

@;{This region's drawing context and given region's drawing context must
 be the same, or they must both be unassociated to any drawing
 context.}
此区域的绘图上下文和给定区域的绘图上下文必须相同，或者两者都不能与任何绘图上下文关联。

@;{The result is consistent across platforms and devices, but it is never
 a true subtraction. A subtraction corresponds to combining the
 sub-paths of this region with the reversed sub-paths of the given
 region, then intersecting the result with this region. This fails as
 a true subtraction, because the boundary of loops (with either
 @racket['odd-even] or @racket['winding] filling) is ambiguous.}
结果在不同的平台和设备上是一致的，但它从来不是真正的减法。减法对应于将该区域的子路径与给定区域的反向子路径组合，然后将结果与该区域相交。这作为一个真正的减法失败，因为循环的边界（使用@racket['odd-even]或@racket['winding]）是不明确的。
}

@defmethod[(union [rgn (is-a?/c region%)])
           void?]{

@;{Sets the region to the union of itself with the given region.}
  将区域设置为自身与给定区域的联合。

@;{This region's drawing context and given region's drawing context must
 be the same, or they must both be unassociated to any drawing
 context.}
  此区域的绘图上下文和给定区域的绘图上下文必须相同，或者两者都不能与任何绘图上下文关联。

@;{A union corresponds to combining the sub-paths of each region into one
 path, using an @racket['odd-even] fill if either of the region uses
 an @racket['odd-even] fill (otherwise using a @racket['winding]
 fill), a @racket['winding] fill in either region uses a
 @racket[winding] fill, or the fill remains a @tech{flexible fill}
 if both paths have a @tech{flexible fill}. Consequently, while the
 result is consistent across platforms and devices, it is a true union
 only for certain input regions. For example, it is a true union for
 non-overlapping @deftech{atomic} and union regions. It is also a true
 union for @tech{atomic} and union regions (potentially overlapping)
 that are all clockwise and use @racket['winding] fill or if the fills
 are all @tech{flexible fills}.}
  联合对应于将每个区域的子路径组合成一条路径，如果其中一个区域使用@racket['odd-even]填充（否则使用@racket['winding]填充），则使用@racket['odd-even]填充；如果两个路径都具有@racket['winding]填充；或者填充保持 @tech{柔性填充（flexible fill）}，则使用@racket['winding]填充；或者填充保持 @tech{柔性填充}。因此，虽然结果在平台和设备之间是一致的，但它仅对某些输入区域是真正的联合。例如，对于不重叠的原子区域和联合区域，它是一个真正的联合。它也是@deftech{原子（atomic）}区域和联合区域（可能重叠）的一个真正的联合，这些区域都是顺时针的，并且使用@racket['winding]填充或如果填充都是@tech{柔性填充}。

}

@defmethod[(xor [rgn (is-a?/c region%)])
           void?]{

@;{Sets the region to the xoring of itself with the given region (i.e.,
 contains points that are enclosed by exactly one of the two regions).}
  将区域设置为具有给定区域（即，包含由两个区域中的一个所包围的点）的自身异或环。

@;{This region's drawing context and given region's drawing context must
 be the same, or they must both be unassociated to any drawing
 context.}
  此区域的绘图上下文和给定区域的绘图上下文必须相同，或者两者都不能与任何绘图上下文关联。

@;{The result is consistent across platforms and devices, but it is not
 necessarily a true xoring. An xoring corresponds to combining the
 sub-paths of this region with the reversed sub-paths of the given
 region. The result uses an @racket['odd-even] fill if either of the
 region uses an @racket['odd-even] fill, a @racket['winding] fill in
 either region uses a @racket[winding] fill, or the fill remains a
 @tech{flexible fill} if both paths have a @tech{flexible
 fill}. Consequently, the result is a reliable xoring only for certain
 input regions. For example, it is reliable for @tech{atomic} and
 xoring regions that all use @racket['even-odd] fill.}
  结果是跨平台和设备一致的，但不一定是真正的异或环。异或环对应于将该区域的子路径与给定区域的反向子路径组合在一起。如果其中一个区域使用@racket['odd-even]填充，则结果使用@racket['odd-even]填充，如果其中一个区域使用@racket[winding]填充，则结果使用@racket['odd-even]填充，如果两条路径都具有灵活的填充，则填充仍为@tech{柔性填充（flexible
 fill）}。因此，结果只对某些输入区域有效。例如，对于所有使用@racket['even-odd]填充的@tech{原子（atomic）}区域和异环区域，它是可靠的。

}}

