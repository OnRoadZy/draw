#lang scribble/doc
@(require scribble/manual scribble/eval scribble/racket racket/runtime-path
          "common.rkt"
          (for-syntax racket/base)
          (for-label racket/math))

@(define draw-eval (make-base-eval))
@interaction-eval[#:eval draw-eval (require racket/class
                                            racket/draw)]
@interaction-eval[#:eval draw-eval (define (copy-bitmap bm0)
                                     (let ([w (send bm0 get-width)]
                                           [h (send bm0 get-height)])
                                       (let ([bm (make-bitmap w h)])
                                         (let ([dc (send bm make-dc)])
                                           (send dc draw-bitmap bm0 0 0)
                                           (send dc set-bitmap #f))
                                          bm)))]
@interaction-eval[#:eval draw-eval (define (line-bitmap mode)
                                     (let* ([bm (make-bitmap 30 4)]
                                            [dc (send bm make-dc)])
                                       (send dc set-smoothing mode)
                                       (send dc draw-line 0 2 30 2)
                                       (send dc set-bitmap #f)
                                       (copy-bitmap bm)))]
@interaction-eval[#:eval draw-eval (define (path-bitmap zee join brush?)
                                     (let* ([bm (make-bitmap 40 40)]
                                            [dc (new bitmap-dc% [bitmap bm])])
                                       (send dc set-smoothing 'aligned)
                                       (send dc set-pen (new pen% [width 5] [join join]))
                                       (if brush?
                                           (send dc set-brush blue-brush)
                                           (send dc set-brush "white" 'transparent))
                                       (send dc draw-path zee 5 5)
                                       (send dc set-bitmap #f)
                                       (copy-bitmap bm)))]

@(define-syntax-rule (define-linked-method name interface)
   (define-syntax name 
     (make-element-id-transformer
      (lambda (stx)
        #'(method interface name)))))
@(define-linked-method draw-line dc<%>)
@(define-linked-method draw-rectangle dc<%>)
@(define-linked-method set-pen dc<%>)
@(define-linked-method set-font dc<%>)
@(define-linked-method set-clipping-region dc<%>)
@(define-linked-method set-alpha dc<%>)
@(define-linked-method get-pen dc<%>)
@(define-linked-method set-brush dc<%>)
@(define-linked-method get-brush dc<%>)
@(define-linked-method set-smoothing dc<%>)
@(define-linked-method draw-path dc<%>)
@(define-linked-method draw-ellipse dc<%>)
@(define-linked-method draw-text dc<%>)
@(define-linked-method draw-bitmap dc<%>)
@(define-linked-method get-text-extent dc<%>)
@(define-linked-method set-text-foreground dc<%>)
@(define-linked-method draw-arc dc<%>)
@(define-linked-method erase dc<%>)
@(define-linked-method set-stipple brush%)
@(define-linked-method line-to dc-path%)
@(define-linked-method curve-to dc-path%)
@(define-linked-method move-to dc-path%)
@(define-linked-method append dc-path%)
@(define-linked-method arc dc-path%)
@(define-linked-method reverse dc-path%)
@(define-linked-method ellipse dc-path%)
@(define-linked-method translate dc<%>)
@(define-linked-method scale dc<%>)
@(define-linked-method rotate dc<%>)
@(define-linked-method set-path region%)

@title[#:tag "overview"]{@;{Overview}概述}

@;{The @racketmodname[racket/draw] library provides a drawing API that is
based on the PostScript drawing model. It supports line drawing, shape
filling, bitmap copying, alpha blending, and affine transformations
(i.e., scale, rotation, and translation).}
@racketmodname[racket/draw]库提供基于PostScript绘图模型的绘图API。它支持线条绘制、形状填充、位图复制、alpha混合和仿射转换（即缩放、旋转和平移）。

@;{@margin-note{See @secref["classes" #:doc '(lib
"scribblings/guide/guide.scrbl")] for an introduction to classes and
interfaces in Racket.}}
@margin-note{请参阅@secref["classes" #:doc '(lib
"scribblings/guide/guide.scrbl")]了解Racket中的类和接口的介绍。}

@;{Drawing with @racketmodname[racket/draw] requires a @deftech{drawing context}
(@deftech{DC}), which is an instance of the @racket[dc<%>]
interface. For example, the @racket[post-script-dc%] class implements
a @racket[dc<%>] for drawing to a PostScript file, while @racket[bitmap-dc%] 
draws to a bitmap. When using the @racketmodname[racket/gui] library for GUIs,
the @method[canvas<%> get-dc] method of a
canvas returns a @racket[dc<%>] instance for drawing into the canvas
window.}
使用@racketmodname[racket/draw]进行绘图需要一个@deftech{绘图上下文（drawing context）}（@deftech{DC}），它是@racket[dc<%>]接口的一个实例。例如，@racket[post-script-dc%]类实现一个@racket[dc<%>]用于绘制PostScript文件，而@racket[bitmap-dc%]用于绘制位图。当对GUI使用@racketmodname[racket/gui]库时，@method[canvas<%> get-dc]方法返回一个@racket[dc<%>]实例，以便在canvas窗口中绘制。

@;{@margin-note{See @secref["canvas-drawing" #:doc '(lib
"scribblings/gui/gui.scrbl")] for an introduction to drawing 
in a GUI window.}}

@margin-note{请参阅@secref["canvas-drawing" #:doc '(lib
"scribblings/gui/gui.scrbl")]了解在GUI窗口中绘图的介绍。}

@; ------------------------------------------------------------
@;{@section{Lines and Simple Shapes}}
@section{线条和简单形状}

@;{To draw into a bitmap, first create the bitmap with
@racket[make-bitmap], and then create a @racket[bitmap-dc%] that draws
into the new bitmap:}
要绘制到位图中，首先使用@racket[make-bitmap]创建位图，然后创建一个@racket[bitmap-dc%]以绘制到新位图中：

@racketblock+eval[
#:eval draw-eval
(define target (make-bitmap 30 30)) (@;{code:comment "A 30x30 bitmap"}code:comment "一个30x30位图")
(define dc (new bitmap-dc% [bitmap target]))
]

@;{Then, use methods like @method[dc<%> draw-line] on the @tech{DC} to draw
into the bitmap. For example, the sequence}
然后，使用诸如在@tech{DC}上@method[dc<%> draw-line]之类的方法绘制到位图。例如，序列

@racketblock+eval[
#:eval draw-eval
(send dc draw-rectangle 
      0 10   (code:comment @#,t{@;{Top-left at (0, 10), 10 pixels down from top-left}左上角（0，10），左上角向下10像素})
      30 10) (code:comment @#,t{@;{30 pixels wide and 10 pixels high}30像素高和10像素宽})
(send dc draw-line 
      0 0    (code:comment @#,t{@;{Start at (0, 0), the top-left corner}开始（0，0），在左上角 })
      30 30) (code:comment @#,t{@;{and draw to (30, 30), the bottom-right corner}画到（30，30），右下角})
(send dc draw-line 
      0 30   (code:comment @#,t{@;{Start at (0, 30), the bottom-left corner}从左下角的（0，30）开始})
      30 0)  (code:comment @#,t{@;{and draw to (30, 0), the top-right corner}画到（30，0），右上角})
]

@;{draws an ``X'' on top of a smaller rectangle into the bitmap @racket[target]. If
you save the bitmap to a file with @racket[(send target #,(:: bitmap% save-file)
"box.png" 'png)], the @filepath{box.png} contains the image}
在较小的矩形顶部绘制一个“X”到@racket[target]中。如果用@racket[(send target #,(:: bitmap% save-file)
"box.png" 'png)]将位图保存到文件中，@filepath{box.png}包含图像

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap target)]}

@;{in PNG format.}
采用PNG格式。

@;{A line-drawing drawing operation like @racket[draw-line] uses the
@tech{DC}'s current @defterm{pen} to draw the line. A pen has a color,
line width, and style, where pen styles include @racket['solid],
@racket['long-dash], and @racket['transparent]. Enclosed-shape
operations like @racket[draw-rectangle] use both the current pen and
the @tech{DC}'s current @deftech{brush}. A brush has a color and style,
where brush styles include @racket['solid], @racket['cross-hatch], and
@racket['transparent].}
@racket[draw-line]之类的线条绘制操作使用@tech{DC}的当前@defterm{笔（pen）}绘制线条。笔具有颜色、线条宽度和样式，其中笔样式包括@racket['solid]、@racket['long-dash]和@racket['transparent]。如@racket[draw-rectangle]这样的封闭形状操作同时使用当前笔和@tech{DC}的当前@deftech{画笔（brush）}。画笔具有颜色和样式，其中画笔样式包括@racket['solid]、@racket['cross-hatch]和@racket['transparent]。

@margin-note{@;{In DrRacket, instead of saving @racket[target] to a file
viewing the image from the file, you can use @racket[(require
racket/gui)] and @racket[(make-object image-snip% target)] to view the
bitmap in the DrRacket interactions window.}
在DrRacket中，您可以使用@racket[(require
racket/gui)]和@racket[(make-object image-snip% target)]在DrRacket交互窗口中查看位图，而不是将@racket[target]保存到从文件查看图像的文件中。}

@;{For example, set the brush and pen before the drawing operations to
draw a thick, red ``X'' on a green rectangle with a thin, blue border:}
例如，在绘图操作之前，将画笔和笔设置为在带有蓝色细边框的绿色矩形上绘制厚的红色“X”：

@racketblock+eval[
#:eval draw-eval
(send dc set-brush "green" 'solid)
(send dc set-pen "blue" 1 'solid)
(send dc draw-rectangle 0 10 30 10)
(send dc set-pen "red" 3 'solid)
(send dc draw-line 0 0 30 30)
(send dc draw-line 0 30 30 0)
]

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap target)]}

@;{To draw a filled shape without an outline, set the pen to
@racket['transparent] mode (with any color and line width). For
example,}
要绘制没有轮廓的填充形状，请将笔设置为@racket['transparent]模式（具有任何颜色和线条宽度）。例如，

@racketblock+eval[
#:eval draw-eval
(send dc set-pen "white" 1 'transparent)
(send dc set-brush "black" 'solid)
(send dc draw-ellipse 5 5 20 20)
]

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap target)]}

@;{By default, a @racket[bitmap-dc%] draws solid pixels without smoothing
the boundaries of shapes. To enable smoothing, set the
smoothing mode to either @racket['smoothed] or @racket['aligned]:}
默认情况下，位图@racket[bitmap-dc%]绘制实体像素而不平滑形状的边界。要启用平滑，请将平滑模式设置为@racket['smoothed]或@racket['aligned]：

@racketblock+eval[
#:eval draw-eval
(send dc set-smoothing 'aligned)
(send dc set-brush "black" 'solid)
(send dc draw-ellipse 4 4 22 22) (code:comment @#,t{@;{a little bigger}稍微大一点})
]

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap target)]}

@;{The difference between @racket['aligned] mode and @racket['smoothed]
mode is related to the relatively coarse granularity of pixels in a
bitmap. Conceptually, drawing coordinates correspond to the lines
between pixels, and the pen is centered on the line. In
@racket['smoothed] mode, drawing on a line causes the pen to draw at
half strength on either side of the line, which produces the following
result for a 1-pixel black pen:}
@racket['aligned]和@racket['smoothed]之间的差异与位图中像素的相对粗粒度有关。从概念上讲，绘图坐标对应于像素之间的线条，笔在线条上居中。在@racket['smoothed]模式下，在线条上绘制会使笔在线条的任一侧以一半的强度绘制，这会为1像素的黑色笔生成以下结果：

@centered[@interaction-eval-show[#:eval draw-eval (line-bitmap 'smoothed)]]

but @racket['aligned] mode shifts drawing coordinates to make the pen
fall on whole pixels, so a 1-pixel black pen draws a single line of
pixels:

@centered[@interaction-eval-show[#:eval draw-eval (line-bitmap 'aligned)]]

@; ------------------------------------------------------------
@;{@section{Pen, Brush, and Color Objects}}
@section{笔、画笔和颜色对象}

@;{The @racket[set-pen] and @racket[set-brush] methods of a @tech{DC}
 accept @racket[pen%] and @racket[brush%] objects, which group
 together pen and brush settings.}
@tech{DC}接受@racket[pen%]和@racket[brush%]对象的@racket[set-pen]和@racket[set-brush]方法，将笔和画笔设置组合在一起。

@racketblock+eval[
#:eval draw-eval
(require racket/math)

(define no-pen (new pen% [style 'transparent]))
(define no-brush (new brush% [style 'transparent]))
(define blue-brush (new brush% [color "blue"]))
(define yellow-brush (new brush% [color "yellow"]))
(define red-pen (new pen% [color "red"] [width 2]))

(define (draw-face dc) 
  (send dc set-smoothing 'aligned)

  (send dc set-pen no-pen) 
  (send dc set-brush blue-brush) 
  (send dc draw-ellipse 25 25 100 100) 

  (send dc set-brush yellow-brush) 
  (send dc draw-rectangle 50 50 10 10) 
  (send dc draw-rectangle 90 50 10 10) 

  (send dc set-brush no-brush) 
  (send dc set-pen red-pen) 
  (send dc draw-arc 37 37 75 75 (* 5/4 pi) (* 7/4 pi)))

(define target (make-bitmap 150 150))
(define dc (new bitmap-dc% [bitmap target]))

(draw-face dc)
]

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap target)]}

@;{The @racket[get-pen] and @racket[get-brush] methods return a
@tech{DC}'s current pen and brush, so they can be restored after
changing them temporarily for drawing.}
@racket[get-pen]和@racket[get-brush]方法返回@tech{DC}当前的笔和画笔，以便在临时更改它们进行绘图后恢复它们。

@;{Besides grouping settings, a @racket[pen%] or @racket[brush%] object
includes extra settings that are not available by using
@racket[set-pen] or @racket[set-brush] directly. For example, a pen or
brush can have a @deftech{stipple}, which is a bitmap that is used
instead of a solid color when drawing. For example, if
@filepath{water.png} has the image}
除了分组设置之外，@racket[pen%]或@racket[brush%]对象还包括其他设置，这些设置不能直接使用@racket[set-pen]或@racket[set-brush]。例如，笔或画笔可以有一个@deftech{点画（stipple）}，点画是在绘制时使用的位图，而不是纯色。例如，如果@filepath{water.png}有图像

@;{We can't just use the runtime path for "water.png" because we need to 
make the eval below work.
 我们不能只使用“water.png”的运行时路径，因为我们需要让下面的eval工作。}
@(define-runtime-path here ".")
@(define-runtime-path water "water.png")
@(draw-eval `(current-directory ,here))

@centered{@image[water]}

@;{then it can be loaded with @racket[read-bitmap] and installed as the
stipple for @racket[blue-brush]:}
然后可以用@racket[read-bitmap]加载并安装为@racket[blue-brush]的点画：

@racketblock+eval[
#:eval draw-eval
(send blue-brush set-stipple (read-bitmap "water.png"))
(send dc erase)
(draw-face dc)
]

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap target)]}

@;{Along similar lines, a @racket[color%] object lets you specify a color
through its red, green, and blue components instead of a built-in
color name. Due to the way that @racket[color%] initialization is
overloaded, use @racket[make-object] instead of @racket[new] to
instantiate @racket[color%], or use the @racket[make-color] function:}
沿着类似的路线，@racket[color%]对象允许您通过其红色、绿色和蓝色组件而不是内置的颜色名称指定颜色。由于@racket[color%]初始化被重载，请使用@racket[make-object]而不是@racket[new]来实例化@racket[color%]或使用@racket[make-color]函数：

@racketblock+eval[
#:eval draw-eval
(define red-pen 
  (new pen% [color (make-color 200 100 150)] [width 2]))
(send dc erase)
(draw-face dc)
]

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap target)]}


@; ------------------------------------------------------------
@;{@section{Transformations}}
@section{变换}

@;{Any coordinates or lengths supplied to drawing commends are
transformed by a @tech{DC}'s current transformation matrix.  The
transformation matrix can scale an image, draw it at an offset, or
rotate all drawing. The transformation can be set directly, or the
current transformation can be transformed further with methods like
@racket[scale], @racket[translate], or @racket[rotate]:}
提供给图纸推荐的任何坐标或长度都由@tech{DC}当前变换矩阵变换。变换矩阵可以缩放图像、在偏移位置绘制图像或旋转所有图形。可以直接设置转换，也可以使用@racket[scale]、@racket[translate]或@racket[rotate]等方法进一步转换当前转换：

@racketblock+eval[
#:eval draw-eval
(send dc erase)
(send dc scale 0.5 0.5)
(draw-face dc)
(send dc rotate (/ pi 2))
(send dc translate 0 150)
(draw-face dc)
(send dc translate 0 -150)
(send dc rotate (/ pi 2))
(send dc translate 150 150)
(draw-face dc)
(send dc translate -150 -150)
(send dc rotate (/ pi 2))
(send dc translate 150 0)
(draw-face dc)
]

@;{Use the @method[dc<%> get-transformation] method to get a @tech{DC}'s
current transformation, and restore a saved transformation (or any
affine transformation) using @method[dc<%> set-transformation].}
使用@method[dc<%> get-transformation]方法获取@tech{DC}的当前转换，并使用 @method[dc<%> set-transformation]恢复保存的转换（或任何仿射转换）。

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap target)]}

@; ------------------------------------------------------------
@;{@section{Drawing Paths}}
@section{绘制路径}

@;{Drawing functions like @racket[draw-line] and @racket[draw-rectangle]
 are actually convenience functions for the more general
 @racket[draw-path] operation. The @racket[draw-path] operation takes
 a @deftech{path}, which describes a set of line segments and curves
 to draw with the pen and---in the case of closed set of lines and
 curves---fill with the current brush.}
@racket[draw-line]和@racket[draw-rectangle]等绘图功能实际上是更一般的绘制路径操作的便利功能。@racket[draw-path]操作采用一个@deftech{路径（path）}，该路径描述要用笔绘制的一组线段和曲线，如果是闭合的一组线和曲线，则使用当前画笔填充。

@;{An instance of @racket[dc-path%] holds a path. Conceptually, a path
 has a current pen position that is manipulated by methods like
 @racket[move-to], @racket[line-to], and @racket[curve-to]. The
 @racket[move-to] method starts a sub-path, and @racket[line-to] and
 @racket[curve-to] extend it. The @racket[close] method moves the pen
 from its current position in a straight line to its starting
 position, completing the sub-path and forming a closed path that can
 be filled with the brush. A @racket[dc-path%] object can have
 multiple closed sub-paths and one final open path, where the open
 path is drawn only with the pen.}
@racket[dc-path%]的实例包含一个路径。从概念上讲，路径有一个当前笔位置，可以通过诸如@racket[move-to]、@racket[line-to]和@racket[curve-to]等方法来操作。@racket[move-to]方法启动子路径，并对其进行@racket[line-to]和@racket[curve-to]延伸。@racket[close]方法将笔从当前位置直线移动到起始位置，完成子路径，形成一个可以用画笔填充的闭合路径。一个@racket[dc-path%]对象可以有多个封闭的子路径和一个最终的开放路径，其中开放路径只能用笔绘制。

@;{For example,}
例如，

@racketblock+eval[
#:eval draw-eval
(define zee (new dc-path%))
(send zee move-to 0 0)
(send zee line-to 30 0)
(send zee line-to 0 30)
(send zee line-to 30 30)
]

@;{creates an open path. Drawing this path with a black pen of width 5
and a transparent brush produces}
创建开放路径。用宽度为5的黑色笔和透明画笔绘制此路径将生成

@centered{@interaction-eval-show[#:eval draw-eval (path-bitmap zee 'round #f)]}

@;{Drawing a single path with three line segments is not the same as
drawing three separate lines. When multiple line segments are drawn at
once, the corner from one line to the next is shaped according to the
pen's join style. The image above uses the default @racket['round]
join style. With @racket['miter], line lines are joined with sharp
corners:}
用三个线段绘制一条路径与绘制三条单独的线不同。当一次绘制多个线段时，从一条线到下一条线的角将根据笔的连接样式进行形状调整。上面的图像使用默认的@racket['round]连接样式。使用@racket['miter]时，线条与尖角相连：

@centered{@interaction-eval-show[#:eval draw-eval (path-bitmap zee 'miter #f)]}

@;{If the sub-path in @racket[zee] is closed with @racket[close], then
all of the corners are joined, including the corner at the initial
point:}
如果@racket[zee]中的子路径用@racket[close]关闭，则所有角都将连接，包括初始点处的角：

@racketblock+eval[
#:eval draw-eval
(send zee close)
]

@centered{@interaction-eval-show[#:eval draw-eval (path-bitmap zee 'miter #f)]}

@;{Using @racket[blue-brush] instead of a transparent brush causes the
interior of the path to be filled:}
使用@racket[blue-brush]而不是透明画笔会导致路径内部填充：

@centered{@interaction-eval-show[#:eval draw-eval (path-bitmap zee 'miter #t)]}

@;{When a sub-path is not closed, it is implicitly closed for brush
filling, but left open for pen drawing. When both a pen and brush are
available (i.e., not transparent), then the brush is used first, so
that the pen draws on top of the brush.}
当子路径未关闭时，它将隐式关闭以进行画笔填充，但为笔绘制而保持打开状态。当笔和画笔都可用（即不透明）时，首先使用画笔，以便笔在画笔顶部绘制。

@;{At this point we can't resist showing an extended example using
@racket[dc-path%] to draw the Racket logo:}
此时，我们无法抗拒使用@racket[dc-path%]绘制Racket徽标的扩展示例：

@racketblock+eval[
#:eval draw-eval
(define red-brush (new brush% [stipple (read-bitmap "fire.png")]))

(define left-lambda-path
  (let ([p (new dc-path%)])
    (send p move-to 153 44)
    (send p line-to 161.5 60)
    (send p curve-to 202.5 49 230 42 245 61)
    (send p curve-to 280.06 105.41 287.5 141 296.5 186)
    (send p curve-to 301.12 209.08 299.11 223.38 293.96 244)
    (send p curve-to 281.34 294.54 259.18 331.61 233.5 375)
    (send p curve-to 198.21 434.63 164.68 505.6 125.5 564)
    (send p line-to 135 572)
    p))

(define left-logo-path
  (let ([p (new dc-path%)])
    (send p append left-lambda-path)
    (send p arc 0 0 630 630 (* 235/360 2 pi) (* 121/360 2 pi) #f)
    p))

(define bottom-lambda-path 
  (let ([p (new dc-path%)])
    (send p move-to 135 572)
    (send p line-to 188.5 564)
    (send p curve-to 208.5 517 230.91 465.21 251 420)
    (send p curve-to 267 384 278.5 348 296.5 312)
    (send p curve-to 301.01 302.98 318 258 329 274)
    (send p curve-to 338.89 288.39 351 314 358 332)
    (send p curve-to 377.28 381.58 395.57 429.61 414 477)
    (send p curve-to 428 513 436.5 540 449.5 573)
    (send p line-to 465 580)
    (send p line-to 529 545)
    p))

(define bottom-logo-path
  (let ([p (new dc-path%)])
    (send p append bottom-lambda-path)
    (send p arc 0 0 630 630 (* 314/360 2 pi) (* 235/360 2 pi) #f)
    p))

(define right-lambda-path
  (let ([p (new dc-path%)])
    (send p move-to 153 44)
    (send p curve-to 192.21 30.69 233.21 14.23 275 20)
    (send p curve-to 328.6 27.4 350.23 103.08 364 151)
    (send p curve-to 378.75 202.32 400.5 244 418 294)
    (send p curve-to 446.56 375.6 494.5 456 530.5 537)
    (send p line-to 529 545)
    p))

(define right-logo-path
  (let ([p (new dc-path%)])
    (send p append right-lambda-path)
    (send p arc 0 0 630 630 (* 314/360 2 pi) (* 121/360 2 pi) #t)    
    p))

(define lambda-path
  (let ([p (new dc-path%)])
    (send p append left-lambda-path)
    (send p append bottom-lambda-path)
    (let ([t (new dc-path%)])
        (send t append right-lambda-path)
        (send t reverse)
        (send p append t))
    (send p close)
    p))

(define (paint-racket dc)
  (send dc set-pen "black" 0 'transparent)
  (send dc set-brush "white" 'solid)
  (send dc draw-path lambda-path)

  (send dc set-pen "black" 4 'solid)

  (send dc set-brush red-brush)
  (send dc draw-path left-logo-path)
  (send dc draw-path bottom-logo-path)

  (send dc set-brush blue-brush)
  (send dc draw-path right-logo-path))

(define racket-logo (make-bitmap 170 170))
(define dc (new bitmap-dc% [bitmap racket-logo]))

(send dc set-smoothing 'smoothed)
(send dc translate 5 5)
(send dc scale 0.25 0.25)
(paint-racket dc)
]

@centered{@interaction-eval-show[#:eval draw-eval racket-logo]}

@;{In addition to the core @racket[move-to], @racket[line-to],
@racket[curve-to], and @racket[close] methods, a @racket[dc-path%]
includes many convenience methods, such as @racket[ellipse] for adding
a closed elliptical sub-path to the path.}
除了核心@racket[move-to]、@racket[line-to]、@racket[curve-to]和@racket[close]方法外，@racket[dc-path%]还包括许多方便的方法，例如@racket[ellipse]用于向路径添加闭合椭圆子路径。

@; ------------------------------------------------------------
@;{@section{Text}}
@section{文本}

@;{Draw text using the @racket[draw-text] method, which takes a string to
draw and a location for the top-left of the drawn text:}
使用@racket[draw-text]方法绘制文本，该方法需要一个字符串以便绘制及一个位置提供绘制文本的左上角：

@racketblock+eval[
#:eval draw-eval
(define text-target (make-bitmap 100 30))
(define dc (new bitmap-dc% [bitmap text-target]))
(send dc set-brush "white" 'transparent)

(send dc draw-rectangle 0 0 100 30)
(send dc draw-text "Hello, World!" 5 1)
]

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap text-target)]}

@;{The font used to draw text is determined by the @tech{DC}'s current
font.  A font is described by a @racket[font%] object and installed
with @racket[set-font]. The color of drawn text which is separate from
either the pen or brush, can be set using
@racket[set-text-foreground].}
用于绘制文本的字体由@tech{DC}的当前字体决定。字体由@racket[font%]对象描述，并用@racket[set-font]安装。可使用@racket[set-text-foreground]设置与笔或画笔分开的绘制文本的颜色。

@racketblock+eval[
#:eval draw-eval
(send dc erase)
(send dc set-font (make-font #:size 14 #:family 'roman 
                             #:weight 'bold))
(send dc set-text-foreground "blue")
(send dc draw-rectangle 0 0 100 30)
(send dc draw-text "Hello, World!" 5 1)
]

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap text-target)]}

@;{To compute the size that will be used by drawn text, use
@racket[get-text-extent], which returns four values: the total width,
total height, difference between the baseline and total height, and
extra space (if any) above the text in a line. For example, the result
of @racket[get-text-extent] can be used to position text within the
center of a box:}
要计算绘制文本将使用的大小，请使用@racket[get-text-extent]，它返回四个值：总宽度、总高度、基线和总高度之间的差以及行中文本上方的额外空间（如果有）。例如，@racket[get-text-extent]的结果可用于将文本定位到框的中心：

@racketblock+eval[
#:eval draw-eval
(send dc erase)
(send dc draw-rectangle 0 0 100 30)
(define-values (w h d a) (send dc get-text-extent "Hello, World!"))
(send dc draw-text "Hello, World!" (/ (- 100 w) 2) (/ (- 30 h) 2))
]

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap text-target)]}


@; ------------------------------------------------------------
@;{@section{Alpha Channels and Alpha Blending}}
@section{alpha通道和alpha混合}

@;{When you create or @racket[erase] a bitmap, the content is
nothing. ``Nothing'' isn't the same as white; it's the absence of
drawing. For example, if you take @racket[text-target] from the
previous section and copy it onto another @tech{DC} using
@racket[draw-bitmap], then the black rectangle and blue text is
transferred, and the background is left alone:}
创建或@racket[erase]位图时，内容为空。“没什么（Nothing）”和白（white）不一样，因为没有绘画。例如，如果从上一节中提取@racket[text-target]，并使用@racket[draw-bitmap]将其复制到另一个@tech{DC}，则会传输黑色矩形和蓝色文本，背景单独保留：

@racketblock+eval[
#:eval draw-eval
(define new-target (make-bitmap 100 30))
(define dc (new bitmap-dc% [bitmap new-target]))
(send dc set-pen "black" 1 'transparent)
(send dc set-brush "pink" 'solid)

(send dc draw-rectangle 0 0 100 30)
(send dc draw-bitmap text-target 0 0)
]

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap new-target)]}

The information about which pixels of a bitmap are drawn (as opposed
to ``nothing'') is the bitmap's @deftech{alpha channel}. Not all
@tech{DC}s keep an alpha channel, but bitmaps created with
@racket[make-bitmap] keep an alpha channel by default. Bitmaps loaded
with @racket[read-bitmap] preserve transparency in the image file
through the bitmap's alpha channel.

An alpha channel isn't all or nothing. When the edges text is
anti-aliased by @racket[draw-text], for example, the pixels are
partially transparent. When the pixels are transferred to another
@tech{DC}, the partially transparent pixel is blended with the target
pixel in a process called @deftech{alpha blending}. Furthermore, a
@tech{DC} has an alpha value that is applied to all drawing
operations; an alpha value of @racket[1.0] corresponds to solid
drawing, an alpha value of @racket[0.0] makes the drawing have no
effect, and values in between make the drawing translucent.

For example, setting the @tech{DC}'s alpha to @racket[0.25] before
calling @racket[draw-bitmap] causes the blue and black of the ``Hello,
World!'' bitmap to be quarter strength as it is blended with the
destination image:

@racketblock+eval[
#:eval draw-eval
(send dc erase)
(send dc draw-rectangle 0 0 100 30)
(send dc set-alpha 0.25)
(send dc draw-bitmap text-target 0 0)
]

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap new-target)]}

@; ------------------------------------------------------------
@section{Clipping}

In addition to tempering the opacity of drawing operations, a
@tech{DC} has a @deftech{clipping region} that constrains all drawing to
inside the region. In the simplest case, a clipping region corresponds
to a closed path, but it can also be the union, intersection,
subtraction, or exclusive-or of two paths.

For example, a clipping region could be set to three circles to clip
the drawing of a rectangle (with the 0.25 alpha still in effect):

@racketblock+eval[
#:eval draw-eval
(define r (new region%))
(let ([p (new dc-path%)])
  (send p ellipse 00 0 35 30)
  (send p ellipse 35 0 30 30)
  (send p ellipse 65 0 35 30)
  (send r set-path p))
(send dc set-clipping-region r)
(send dc set-brush "green" 'solid)
(send dc draw-rectangle 0 0 100 30)
]

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap new-target)]}

The clipping region can be viewed as a convenient alternative to path
filling or drawing with stipples. Conversely, stippled drawing can be
viewed as a convenience alternative to clipping repeated calls of
@racket[draw-bitmap].

Combining regions with @racket[pen%] objects that have gradients, however,
is more than just a convenience, as it allows us to draw shapes in combinations
we could not otherwise draw. To illustrate, here is some code that draws
text with its reflection below it.

@racketblock+eval[
#:eval draw-eval
(code:comment "First compute the size of the text we're going to draw,")
(code:comment "using a small bitmap that we never draw into.")
(define bdc (new bitmap-dc% [bitmap (make-bitmap 1 1)]))
(define str "Racketeers, ho!")
(define the-font (make-font #:size 24 #:family 'swiss 
                            #:weight 'bold))
(define-values (tw th)
  (let-values ([(tw th ta td)
                (send dc get-text-extent str the-font)])
    (values (inexact->exact (ceiling tw))
            (inexact->exact (ceiling th)))))

(code:comment "Now we can create a correctly sized bitmap to")
(code:comment "actually draw into and enable smoothing.")
(send bdc set-bitmap (make-bitmap tw (* th 2)))
(send bdc set-smoothing 'smoothed)

(code:comment "next, build a path that contains the outline of the text")
(define upper-path (new dc-path%))
(send upper-path text-outline the-font str 0 0)

(code:comment "next, build a path that contains the mirror image")
(code:comment "outline of the text")
(define lower-path (new dc-path%))
(send lower-path text-outline the-font str 0 0)
(send lower-path transform (vector 1 0 0 -1 0 0))
(send lower-path translate 0 (* 2 th))

(code:comment "This helper accepts a path, sets the clipping region")
(code:comment "of bdc to be the path (but in region form), and then")
(code:comment "draws a big rectangle over the whole bitmap.")
(code:comment "The brush will be set differently before each call to")
(code:comment "draw-path, in order to draw the text and then to draw")
(code:comment "the shadow.")
(define (draw-path path)
  (define rgn (new region%))
  (send rgn set-path path)
  (send bdc set-clipping-region rgn)
  (send bdc set-pen "white" 1 'transparent)
  (send bdc draw-rectangle 0 0 tw (* th 2))
  (send bdc set-clipping-region #f))

(code:comment "Now we just draw the upper-path with a solid brush")
(send bdc set-brush "black" 'solid)
(draw-path upper-path)

(code:comment "To draw the shadow, we set up a brush that has a")
(code:comment "linear gradient over the portion of the bitmap")
(code:comment "where the shadow goes")
(define stops
  (list (list 0 (make-color 0 0 0 0.4))
        (list 1 (make-color 0 0 0 0.0))))
(send bdc set-brush 
      (new brush% 
           [gradient 
            (new linear-gradient% 
                 [x0 0]
                 [y0 th]
                 [x1 0]
                 [y1 (* th 2)]
                 [stops stops])]))
(draw-path lower-path)                 
]

And now the bitmap in @racket[bdc] has ``Racketeers, ho!'' with
a mirrored version below it.

@centered{@interaction-eval-show[#:eval draw-eval (copy-bitmap (send bdc get-bitmap))]}


@; ------------------------------------------------------------
@section[#:tag "Portability"]{Portability and Bitmap Variants}

Drawing effects are not completely portable across platforms, across
different classes that implement @racket[dc<%>], or different
kinds of bitmaps. Fonts and text, especially, can vary across
platforms and types of @tech{DC}, but so can the precise set of pixels
touched by drawing a line.

Different kinds of bitmaps can produce different results:

@itemlist[

 @item{Drawing to a bitmap produced by @racket[make-bitmap] (or
       instantiated from @racket[bitmap%]) draws in the most
       consistent way across platforms.}

 @item{Drawing to a bitmap produced by @racket[make-platform-bitmap]
       uses platform-specific drawing operations as much as possible.
       On Windows, however, a bitmap produced by
       @racket[make-platform-bitmap] has no alpha channel, and it uses
       more constrained resources than one produced by
       @racket[make-bitmap] (due to a system-wide, per-process GDI limit).

       As an example of platform-specific difference, text is smoothed
       by default with sub-pixel anti-aliasing on Mac OS, while text
       smoothing in a @racket[make-bitmap] result uses only grays.
       Line or curve drawing may touch different pixels than in a
       bitmap produced by @racket[make-bitmap], and bitmap scaling may
       differ.

       A possible approach to dealing with the GDI limit under Windows
       is to draw into the result of a @racket[make-platform-bitmap]
       and then copy the contents of the drawing into the result of a
       @racket[make-bitmap]. This approach preserves the drawing
       results of @racket[make-platform-bitmap], but it retains
       constrained resources only during the drawing process.}

 @item{Drawing to a bitmap produced by @racket[make-screen-bitmap]
       from @racketmodname[racket/gui/base] uses the same
       platform-specific drawing operations as drawing into a
       @racket[canvas%] instance. A bitmap produced by
       @racket[make-screen-bitmap] uses the same platform-specific
       drawing as @racket[make-platform-bitmap] on Windows or Mac OS, but possibly scaled, and it may be scaled or sensitive to the X11
       server on Unix.
 
       On Mac OS, when the main screen is in Retina mode (at the
       time that the bitmap is created), the bitmap is also internally
       scaled so that one drawing unit uses two pixels. Similarly, on
       Windows or Unix, when the main display's text scale is configured at
       the operating-system level (see @secref[#:doc '(lib
       "scribblings/gui/gui.scrbl") "display-resolution"]), the bitmap
       is internally scaled, where common configurations map a drawing
       unit to @math{1.25}, @math{1.5}, or @math{2} pixels.

       Use @racket[make-screen-bitmap] when drawing to a bitmap as an
       offscreen buffer before transferring an image to the screen, or
       when consistency with screen drawing is needed for some other
       reason.}

 @item{A bitmap produced by @xmethod[canvas% make-bitmap] from
       @racketmodname[racket/gui/base] is like a bitmap from
       @racket[make-screen-bitmap], but on Mac OS, the bitmap is
       optimized for drawing to the screen (by taking advantage of
       system APIs that can, in turn, take advantage of graphics
       hardware).

       Use @xmethod[canvas% make-bitmap] for similar purposes
       as @racket[make-screen-bitmap], particularly when the bitmap
       will be drawn later to a known target canvas.}

]

@close-eval[draw-eval]
