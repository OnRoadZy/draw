#lang scribble/doc
@(require "common.rkt"
          (for-label (only-in ffi/unsafe cpointer?)))

@defclass/title[bitmap% object% ()]{

@;{A @racket[bitmap%] object is a pixel-based image, either monochrome,
 color, or color with an alpha channel. See also @racket[make-bitmap],
 @racket[make-platform-bitmap], @racket[make-screen-bitmap] (from
 @racketmodname[racket/gui/base]), @xmethod[canvas% make-bitmap] (from
 @racketmodname[racket/gui/base]), and @secref["Portability"].}
  @racket[bitmap%]对象是基于像素的图像，可以是单色、彩色，也可以是带alpha通道的彩色。另请参见@racket[make-bitmap]、@racket[make-platform-bitmap]、@racket[make-screen-bitmap] (来自@racketmodname[racket/gui/base])、@xmethod[canvas% make-bitmap] (来自@racketmodname[racket/gui/base])和@secref["Portability"]。

@;{A bitmap has a @deftech{backing scale}, which is the number of pixels
 that correspond to a drawing unit for the bitmap, either when the
 bitmap is used as a target for drawing or when the bitmap is drawn
 into another context.  For example, on Mac OS when the main monitor
 is in Retina mode, @racket[make-screen-bitmap] returns a bitmap whose
 backing scale is @racket[2.0]. On Windows and Unix, the backing scale of a screen
 bitmap corresponds to the system-wide text scale (see @secref[#:doc '(lib
 "scribblings/gui/gui.scrbl") "display-resolution"]). A monochrome bitmap always
 has a backing scale of @racket[1.0].}
  位图有一个@deftech{备份比例（backing scale）}，即当位图用作绘图目标或当位图绘制到另一个上下文中时，与位图的绘图单位相对应的像素数。例如，在Mac OS上，当主监视器处于“视网膜（Retina）”模式时，@racket[make-screen-bitmap]将返回一个支持比例为@racket[2.0]的位图。在Windows和Unix上，屏幕位图的备份比例对应于系统范围的文本比例（请参见@secref[#:doc '(lib
 "scribblings/gui/gui.scrbl") "显示分辨率"]）。单色位图的支持比例始终为@racket[1.0]。

@;{A bitmap is convertible to @racket['png-bytes] through the
@racketmodname[file/convertible] protocol.}
  位图可以通过@racketmodname[file/convertible]协议转换为@racket['png-bytes]。


@defconstructor*/make[(([width exact-positive-integer?]
                        [height exact-positive-integer?]
                        [monochrome? any/c #f]
                        [alpha? any/c #f]
                        [backing-scale (>/c 0.0) 1.0])
                       ([in (or/c path-string? input-port?)]
                        [kind (or/c 'unknown 'unknown/mask 'unknown/alpha
                                    'gif 'gif/mask 'gif/alpha 
                                    'jpeg 'jpeg/alpha
                                    'png 'png/mask 'png/alpha
                                    'xbm 'xbm/alpha 'xpm 'xpm/alpha
                                    'bmp 'bmp/alpha)
                              'unknown]
                        [bg-color (or/c (is-a?/c color%) #f) #f]
                        [complain-on-failure? any/c #f]
                        [backing-scale (>/c 0.0) 1.0])
                       ([bits bytes?]
                        [width exact-positive-integer?]
                        [height exact-positive-integer?]))]{

@;{The @racket[make-bitmap], @racket[make-monochrome-bitmap], and
 @racket[read-bitmap] functions create @racket[bitmap%] instances, but
 they are also preferred over using @racket[make-object] 
 with @racket[bitmap%] directly, because the functions are
 less overloaded and they enable alpha channels by default.
 See also @secref["Portability"].}
  @racket[make-bitmap]、@racket[make-monochrome-bitmap]和@racket[read-bitmap]函数创建@racket[bitmap%]实例，但它们也比直接使用带@racket[bitmap%]的@racket[make-object]更受欢迎，因为函数的重载程度较低，默认情况下启用alpha通道。另见@secref["Portability"]。
 
@;{When @racket[width] and @racket[height] are provided: Creates a new
 bitmap. If @racket[monochrome?] is true, the bitmap is monochrome; if
 @racket[monochrome?] is @racket[#f] and @racket[alpha?] is true, the
 bitmap has an alpha channel; otherwise, the bitmap is color without
 an alpha channel. The @racket[backing-scale] argument sets the
 bitmap's @tech{backing scale}, and it must be @racket[1.0] if
 @racket[monochrome] is true.
 The initial content of the bitmap is ``empty'': all white, and with
 zero alpha in the case of a bitmap with an alpha channel.}
  提供@racket[width]和@racket[height]时：创建一个新位图。如果@racket[monochrome?]为真，位图是单色的；如果@racket[monochrome?]为@racket[#f]和@racket[alpha?]为真，则位图具有alpha通道；否则，位图是没有alpha通道的彩色。@racket[backing-scale]参数设置位图的@tech{备份比例（backing scale）}，如果@racket[monochrome]为真，则必须为@racket[1.0]。位图的初始内容为“空（empty）”：全部为白色，如果位图具有Alpha通道，则为零Alpha。

@;{When @racket[in] is provided: Creates a bitmap from a file format,
 where @racket[kind] specifies the format. See @method[bitmap%
 load-file] for details. The @racket[backing-scale] argument sets the
 bitmap's @tech{backing scale}, so that the bitmap's size (as reported
 by @method[bitmap% get-width] and @method[bitmap% get-height]) is the
 @racket[ceiling] of the bitmap's size from @racket[in] divided by
 @racket[backing-scale]; the backing scale must be @racket[1.0] if the
 bitmap is monocrhome or loaded with a mask.}
 如果提供了@racket[in]：从文件格式创建位图，其中@racket[kind]指定格式。有关详细信息，请参见@method[bitmap%
 load-file]。@racket[backing-scale]参数设置位图的@tech{备份比例}，以便位图的大小（由@method[bitmap% get-width]和@method[bitmap% get-height]报告）是位图大小的@racket[ceiling]（从@racket[in]除以@racket[backing-scale]）；如果位图是单色或加载了一个遮罩，备份比例必须为@racket[1.0]。 

@;{When a @racket[bits] byte string is provided: Creates a monochrome
 bitmap from an array of bit values, where each byte in @racket[bits]
 specifies eight bits, and padding bits are added so that each bitmap
 line starts on a character boundary. A @racket[1] bit value indicates
 black, and @racket[0] indicates white. If @racket[width] times
 @racket[height] is larger than 8 times the length of @racket[bits],
 @|MismatchExn|.}
  提供@racket[bits]字节字符串时：从位值数组创建单色位图，其中每个@racket[bits]中的字节指定8位，并添加填充位，以便每个位图行从字符边界开始。@racket[1]位值表示黑色，@racket[0]表示白色。如果@racket[width]乘以@racket[height]大于@racket[bits]长度的8倍，@|MismatchExn|。

@;{@history[#:changed "1.1" @elem{Added the @racket[backing-scale]
optional arguments.}]}
  @history[#:changed "1.1" @elem{添加@racket[backing-scale]可选参数。}]
 }

@defmethod[(get-argb-pixels [x exact-nonnegative-integer?]
                            [y exact-nonnegative-integer?]
                            [width exact-nonnegative-integer?]
                            [height exact-nonnegative-integer?]
                            [pixels (and/c bytes? (not/c immutable?))]
                            [just-alpha? any/c #f]
                            [pre-multiplied? any/c #f]
                            [#:unscaled? unscaled? any/c #f])
           void?]{

@;{Produces the same result as @xmethod[bitmap-dc% get-argb-pixels] when
@racket[unscaled?] is @racket[#f], but the bitmap does not have to be
selected into the DC (and this method works even if the bitmap is
selected into another DC, attached as a button label, etc.).}
  在@racket[unscaled?]为@racket[#f]时，生成与@xmethod[bitmap-dc% get-argb-pixels]相同的结果，但位图不必选入DC（即使位图选入另一个DC，附加为按钮标签等，此方法也有效）。

@;{If the bitmap has a @tech{backing scale} other than @racket[1.0] and
@racket[unscaled?] is true, then the result corresponds to the
bitmap's pixels ignoring the @tech{backing scale}. In that case,
@racket[x], @racket[y], @racket[width], and @racket[height] are
effectively in pixels instead of drawing units.}
  如果位图的@tech{备份比例（backing scale）}不是@racket[1.0]，并且@racket[unscaled?]为真，则结果与忽略@tech{备份比例}的位图像素相对应。在这种情况下，@racket[x]、@racket[y]、@racket[width]和@racket[height]有效地以像素为单位，而不是以绘图为单位。

@;{@history[#:changed "1.1" @elem{Added the @racket[#:unscaled?]
optional argument.}]}
  @history[#:changed "1.1" @elem{添加@racket[#:unscaled?]可选参数。}]
  }


@defmethod[(get-backing-scale)
           (>/c 0.0)]{

@;{Returns the bitmap's @tech{backing scale}.}
  返回位图的@tech{备份比例（backing scale）}。

@history[#:added "1.1"]}


@defmethod[(get-depth)
           exact-nonnegative-integer?]{

@;{Gets the color depth of the bitmap, which is @racket[1] for a
monochrome bitmap and @racket[32] for a color bitmap. See also
@method[bitmap% is-color?].}
获取位图的颜色深度，单色位图为@racket[1]，彩色位图为@racket[32]。参见@method[bitmap% is-color?]。
}


@defmethod[(get-handle) cpointer?]{

@;{Returns a low-level handle to the bitmap content. Currently, on all
platforms, a handle is a @tt{cairo_surface_t}. For a bitmap created
with @racket[make-bitmap], the handle is specifically a Cairo
image surface.}
 返回位图内容的低级句柄。目前，在所有平台上，句柄都是@tt{cairo_surface_t}。对于使用@racket[make-bitmap]创建的位图，句柄是Cairo图像曲面。
 }


@defmethod[(get-height)
           exact-positive-integer?]{

@;{Gets the height of the bitmap in drawing units (which is the same as
pixels if the @tech{backing scale} is 1.0).}
 以绘图单位获取位图的高度（如果@tech{备份比例}为1.0，则与像素相同）。
 }


@defmethod[(get-loaded-mask)
           (or/c (is-a?/c bitmap%) #f)]{

@;{Returns a mask bitmap that is stored with this bitmap.}
  返回与此位图一起存储的掩码位图。

@;{When a GIF file is loaded with @racket['gif/mask] or
 @racket['unknown/mask] and the file contains a transparent ``color,''
 a mask bitmap is generated to identify the transparent pixels. The
 mask bitmap is monochrome, with white pixels where the loaded bitmap
 is transparent and black pixels everywhere else.}
  当加载带有@racket['gif/mask]或@racket['unknown/mask]且文件包含透明“彩色”的GIF文件时，将生成一个遮罩位图来标识透明像素。遮罩位图是单色的，其中白色像素的加载位图是透明的，黑色像素是其他地方。

@;{When a PNG file is loaded with @racket['png/mask] or
 @racket['unknown/mask] and the file contains a mask or alpha channel,
 a mask bitmap is generated to identify the mask or alpha channel.  If
 the file contains a mask or an alpha channel with only extreme
 values, the mask bitmap is monochrome, otherwise it is grayscale
 (representing the alpha channel inverted).}
  当一个PNG文件加载了@racket['png/mask]或@racket['unknown/mask]并且该文件包含一个mask或alpha通道时，会生成一个mask位图来标识该mask或alpha通道。如果文件包含只有极值的mask或alpha通道，则mask位图为单色，否则为灰度（表示反转的alpha通道）。

@;{When an XPM file is loaded with @racket['xpm/mask] or
 @racket['unknown/mask], a mask bitmap is generated to indicate which
 pixels are set.}
  当用@racket['xpm/mask]或@racket['unknown/mask]加载XPM文件时，将生成一个遮罩位图，以指示设置了哪些像素。

@;{When @racket['unknown/alpha] and similar modes are used to load a
 bitmap, transparency information is instead represented by an alpha
 channel, not by a mask bitmap.}
  当使用@racket['unknown/alpha]和类似模式加载位图时，透明度信息由阿尔法通道表示，而不是由遮罩位图表示。

@;{Unlike an alpha channel, the mask bitmap is @italic{not} used
 automatically by drawing routines. The mask bitmap can be extracted
 and supplied explicitly as a mask (e.g., as the sixth argument to
 @method[dc<%> draw-bitmap]). The mask bitmap is used by
 @method[bitmap% save-file] when saving a bitmap as @racket['png] if
 the mask has the same dimensions as the saved bitmap. The mask bitmap
 is also used automatically when the bitmap is a control label.}
  与alpha通道不同，绘制例程@italic{不会}自动使用遮罩位图。可以显式提取和提供遮罩位图作为遮罩（例如，作为@method[dc<%> draw-bitmap]的第六个参数）。当将位图保存为@racket['png]时，如果遮罩的尺寸与@method[bitmap% save-file]相同，则保存文件将使用遮罩位图。当位图是控件标签时，也会自动使用遮罩位图。
}

@defmethod[(get-width)
           exact-positive-integer?]{

@;{Gets the width of the bitmap in drawing units (which is the same as
pixels of the @tech{backing scale} is 1.0).}
 获取位图的宽度（以绘图单位表示）（与@tech{备份比例}的像素相同）为1.0。
 }


@defmethod[(has-alpha-channel?)
           boolean?]{

@;{Returns @racket[#t] if the bitmap has an alpha channel,
@racket[#f] otherwise.}
  如果位图有alpha通道，则返回@racket[#t]，否则返回@racket[#f]。
}

@defmethod[(is-color?)
           boolean?]{

@;{Returns @racket[#f] if the bitmap is monochrome, @racket[#t] otherwise.}
如果位图是单色的，则返回@racket[#f]，否则返回@racket[#t]。
}

@defmethod[(load-file [in (or/c path-string? input-port?)]
                      [kind (or/c 'unknown 'unknown/mask 'unknown/alpha
                                  'gif 'gif/mask 'gif/alpha 
                                  'jpeg 'jpeg/alpha
                                  'png 'png/mask 'png/alpha
                                  'xbm 'xbm/alpha 'xpm 'xpm/alpha
                                  'bmp 'bmp/alpha)
                            'unknown]
                      [bg-color (or/c (is-a?/c color%) #f) #f]
                      [complain-on-failure? any/c #f])
           boolean?]{

@;{Loads a bitmap from a file format that read from @racket[in], unless
 the bitmap was produced by @racket[make-platform-bitmap], @racket[make-screen-bitmap],
 or @xmethod[canvas% make-bitmap] (in which case @|MismatchExn|).
 If the bitmap is in use by a
 @racket[bitmap-dc%] object or a control, the image data is not
 loaded. The bitmap changes its size and depth to match that of 
 the loaded image. If an error is encountered when reading the file format,
 an exception is raised only if @racket[complain-on-failure?] is true (which is
 @emph{not} the default).}
  从@racket[in]读取的文件格式加载位图，除非位图是由@racket[make-platform-bitmap]、@racket[make-screen-bitmap]或@xmethod[canvas% make-bitmap]（在这种情况下，@|MismatchExn|）产生。如果位图由@racket[bitmap-dc%]对象或控件使用，则不会加载图像数据。位图会更改其大小和深度以匹配加载的图像。如果在读取文件格式时遇到错误，则只有如果@racket[complain-on-failure?]为真才会引发异常（@emph{不是}默认值）。

@;{The @racket[kind] argument specifies the file's format:}
@racket[kind]参数指定文件的格式：

@itemize[

@item{@racket['unknown]@;{ --- examine the file to determine its format; creates
  either a monochrome or color bitmap without an alpha channel}
——检查文件以确定其格式；创建没有alpha通道的单色或彩色位图；
   }
@item{@racket['unknown/mask]@;{ --- like @racket['unknown], but see
  @method[bitmap% get-loaded-mask]}
——类似于@racket['unknown]，但请参见@method[bitmap% get-loaded-mask]；
   }
@item{@racket['unknown/alpha]@;{ --- like @racket['unknown], but if the bitmap is
  color, it has an alpha channel, and transparency in the image file is
  recorded in the alpha channel}
  ——类似于@racket['unknown]，但如果位图是彩色的，则它具有alpha通道，并且图像文件中的透明度记录在alpha通道中；
       }
@item{@racket['gif]@;{ --- load a @as-index{GIF} bitmap file, creating a color
  bitmap}
   ——加载一个@as-index{GIF}位图文件，创建一个彩色位图；
   }
@item{@racket['gif/mask]@;{ --- like @racket['gif], but see
  @method[bitmap% get-loaded-mask]}
   ——类似@racket['gif]，但请参见@method[bitmap% get-loaded-mask]；
   }
@item{@racket['gif/alpha]@;{ --- like @racket['gif], but with an alpha channel}
   ——类似@racket['gif]，但带有alpha通道；
   }
@item{@racket['jpeg]@;{ --- load a @as-index{JPEG} bitmap file, creating a color
  bitmap}
——加载@as-index{JPEG}位图文件，创建彩色位图；
   }
@item{@racket['jpeg/alpha]@;{ --- like @racket['jpeg], but with an alpha channel}
——类似于@racket['jpeg]，但带有alpha通道
   }
@item{@racket['png]@;{ --- load a @as-index{PNG} bitmap file, creating a color or
  monochrome bitmap}
——加载@as-index{PNG}位图文件，创建彩色或单色位图；
   }
@item{@racket['png/mask]@;{ --- like @racket['png], but see
  @method[bitmap% get-loaded-mask]}
——类似于@racket['png]，但请参见@method[bitmap% get-loaded-mask]；
   }
@item{@racket['png/alpha]@;{ --- like @racket['png], but always color and with an
  alpha channel}
——类似于@racket['png]，但始终使用彩色和alpha通道；
   }
@item{@racket['xbm]@;{ --- load an X bitmap (@as-index{XBM}) file; creates a
  monochrome bitmap}
——加载X位图（@as-index{XBM}）文件；创建单色位图；
   }
@item{@racket['xbm/alpha]@;{ --- like @racket['xbm], but creates a color bitmap
  with an alpha channel}
——类似于@racket['xbm]，但使用alpha通道创建彩色位图；
   }
@item{@racket['xpm]@;{ --- load an @as-index{XPM} bitmap file, creating a color
  bitmap}
——加载@as-index{XPM}位图文件，创建彩色位图；
   }
@item{@racket['xpm/alpha]@;{ --- like @racket['xpm], but with an alpha channel}
——类似于@racket['xpm]，但带有alpha通道；
   }
@item{@racket['bmp]@;{ --- load a Windows bitmap (BMP) file, creating a color bitmap}
——加载Windows位图（BMP）文件，创建彩色位图；
   }
@item{@racket['bmp/alpha]@;{ --- like @racket['bmp], but with an alpha channel}
——类似于@racket['bmp]，但带有alpha通道
   }
]

@;{An XBM image is always loaded as a monochrome bitmap. A 1-bit
 grayscale PNG without a mask or alpha channel is also loaded as a
 monochrome bitmap. An image in any other format is always loaded as a
 color bitmap.}
  XBM图像总是作为单色位图加载。没有遮罩或阿尔法通道的1位灰度PNG也加载为单色位图。任何其他格式的图像总是作为彩色位图加载。

@;{For PNG and BMP loading, if @racket[bg-color] is not @racket[#f], then it is
 combined with the file's alpha channel or mask (if any) while loading
 the image; in this case, no separate mask bitmap is generated and the
 alpha channel fills the bitmap, even if @racket['unknown/mask],
 @racket['png/mask] is specified for the format. If the format is
 specified as @racket['unknown] or @racket['png] and @racket[bg-color]
 is not specified, the PNG file is consulted for a background color to
 use for loading, and white is used if no background color is
 indicated in the file.}
  对于PNG和BMP加载，如果@racket[bg-color]不是@racket[#f]，则在加载图像时将其与文件的alpha通道或遮罩（如果有的话）组合；在这种情况下，不会生成单独的遮罩位图，并且alpha通道填充位图，即使为格式指定了@racket['unknown/mask]，也不会指定@racket['png/mask]。如果将格式指定为@racket['unknown]或@racket['png]，并且未指定@racket[bg-color]，则将参考PNG文件以获取用于加载的背景色，如果文件中未指示背景色，则使用白色。

@;{@index["gamma correction"]{In} all PNG-loading modes, gamma correction
 is applied when the file provides a gamma value, otherwise gamma
 correction is not applied. The current display's gamma factor is
 determined by the @indexed-envvar{SCREEN_GAMMA} environment
 variable if it is defined. If the preference and environment variable
 are both undefined, a platform-specific default is used.}
  @index["gamma correction"]{在}所有PNG加载模式中，当文件提供gamma值时应用gamma校正，否则不应用gamma校正。当前显示的gamma因子由@indexed-envvar{SCREEN_GAMMA}环境变量（如果定义了）确定。如果preference和environment变量都未定义，则使用平台特定的默认值。

@;{After a bitmap is created, @method[bitmap% load-file] can be used
 only if the bitmap's @tech{backing scale} is @racket[1.0].}
创建位图后，仅当位图的@tech{备份比例}为@racket[1.0]时，才能使用@method[bitmap% load-file]。
 }


@defmethod[(make-dc)
           (is-a?/c bitmap-dc%)]{

@;{Return @racket[(make-object bitmap-dc% this)].}
返回@racket[(make-object bitmap-dc% this)]。
 }


@defmethod[(ok?)
           boolean?]{

@;{Returns @racket[#t] if the bitmap is valid in the sense that an image
 file was loaded successfully. If @method[bitmap% ok?] returns
 @racket[#f], then drawing to or from the bitmap has no effect.}
  如果位图在成功加载图像文件的意义上有效，则返回@racket[#t]。如果@method[bitmap% ok?]返回@racket[#f]，那么在位图中绘制或从位图中绘制都无效。

}


@defmethod[(save-file [name (or/c path-string? output-port?)]
                      [kind (or/c 'png 'jpeg 'xbm 'xpm 'bmp)]
                      [quality (integer-in 0 100) 75]
                      [#:unscaled? unscaled? any/c #f])
           boolean?]{

@;{Writes a bitmap to the named file or output stream.}
  将位图写入命名文件或输出流。

@;{The @racket[kind] argument determined the type of file that is created,
 one of:}
 @racket[kind]参数确定了创建的文件类型，其中一个： 

@itemize[

 @item{@racket['png]@;{ --- save a @as-index{PNG} file}
        ——保存@as-index{PNG}文件；}

 @item{@racket['jpeg]@;{ --- save a @as-index{JPEG} file}
        ——保存@as-index{JPEG}文件；}

 @item{@racket['xbm]@;{ --- save an X bitmap (@as-index{XBM}) file}
        ——保存X位图（@as-index{XBM}）文件；}

 @item{@racket['xpm]@;{ --- save an @as-index{XPM} bitmap file}
        ——保存@as-index{XPM}位图文件；}

 @item{@racket['bmp]@;{ --- save a Windows bitmap file}
        ——保存Windows位图文件。}

]

@;{The @racket[quality] argument is used only for saving as @racket['jpeg], in
 which case it specifies the trade-off between image precision (high
 quality matches the content of the @racket[bitmap%] object more
 precisely) and size (low quality is smaller).}
  @racket[quality]参数仅用于保存为@racket['jpeg]，在这种情况下，它指定图像精度（高质量与@racket[bitmap%]对象的内容更精确地匹配）和大小（低质量更小）之间的权衡。

@;{When saving as @racket['png], if @method[bitmap% get-loaded-mask]
 returns a bitmap of the same size as this one, a grayscale version is
 included in the PNG file as the alpha channel.}
  当保存为@racket['png]时，如果@method[bitmap% get-loaded-mask]返回的位图与此位图的大小相同，则灰度版本将作为alpha通道包含在PNG文件中。

@;{A monochrome bitmap saved as @racket['png] without a mask bitmap
 produces a 1-bit grayscale PNG file (which, when read with
 @method[bitmap% load-file], creates a monochrome @racket[bitmap%]
 object.)}
  保存为@racket['png]的单色位图（不带遮罩位图）将生成一个1位灰度PNG文件（当使用@method[bitmap% load-file]读取时，该文件将创建一个单色@racket[bitmap%]对象）。

@;{If the bitmap has a @tech{backing scale} other than 1.0, then it is
 effectively converted to a single pixel per drawing unit before
 saving unless @racket[unscaled?] is true.}
  如果位图的@tech{备份比例}不是1.0，那么在保存之前，它会有效地转换为每个绘图单位的单个像素，除非@racket[unscaled?]是真的。

@;{@history[#:changed "1.1" @elem{Added the @racket[#:unscaled?]
optional argument.}]}
@history[#:changed "1.1" @elem{添加@racket[#:unscaled?]可选参数。}]
 }


@defmethod[(set-argb-pixels [x real?]
                            [y real?]
                            [width exact-nonnegative-integer?]
                            [height exact-nonnegative-integer?]
                            [pixels bytes?]
                            [just-alpha? any/c #f]
                            [pre-multiplied? any/c #f]
                            [#:unscaled? unscaled? any/c #f])
           void?]{

@;{The same as @xmethod[bitmap-dc% set-argb-pixels] when
@racket[unscaled?] is @racket[#f], but the bitmap does not have to be
selected into the DC.}
  当@racket[unscaled?]为@racket[#f]时，与@xmethod[bitmap-dc% set-argb-pixels]相同，但不必将位图选入DC。

@;{If the bitmap has a @tech{backing scale} other than @racket[1.0] and
@racket[unscaled?] is true, then pixel values are installed ignoring
the @tech{backing scale}. In that case, @racket[x], @racket[y],
@racket[width], and @racket[height] are effectively in pixels instead
of drawing units.}
  如果位图的@tech{备份比例}不是@racket[1.0]，并且@racket[unscaled?]为真，则忽略备份比例安装像素值。在这种情况下，@racket[x]、@racket[y]、@racket[width]和@racket[height]有效地以像素为单位，而不是以绘图单位。

@;{@history[#:changed "1.1" @elem{Added the @racket[#:unscaled?]
optional argument.}]}
 @history[#:changed "1.1" @elem{添加@racket[#:unscaled?]可选参数。}]
 }


@defmethod[(set-loaded-mask [mask (is-a?/c bitmap%)])
           void?]{

@;{See @method[bitmap% get-loaded-mask].
  参见@method[bitmap% get-loaded-mask]}

}}

