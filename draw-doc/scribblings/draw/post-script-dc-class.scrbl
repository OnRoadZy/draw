#lang scribble/doc
@(require "common.rkt")

@defclass/title[post-script-dc% object% (dc<%>)]{

@;{A @racket[post-script-dc%] object is a PostScript device context, that
 can write PostScript files on any platform. See also
 @racket[ps-setup%] and @racket[pdf-dc%].}
  @racket[post-script-dc%]对象是PostScript设备上下文，可以在任何平台上写入PostScript文件。另请参见@racket[ps-setup%]和@racket[pdf-dc%]。

@|PrintNote|

@;{See also @racket[printer-dc%].}
  另参见@racket[printer-dc%]。


@defconstructor[([interactive any/c #t]
                 [parent (or/c (is-a?/c frame%) (is-a?/c dialog%) #f) #f]
                 [use-paper-bbox any/c #f]
                 [as-eps any/c #t]
                 [width (or/c (and/c real? (not/c negative?)) #f) #f]
                 [height (or/c (and/c real? (not/c negative?)) #f) #f]
                 [output (or/c path-string? output-port? #f) #f])]{

@;{If @racket[interactive] is true, the user is given a dialog for
 setting printing parameters (see @racket[get-ps-setup-from-user]);
 the resulting configuration is installed as the current
 configuration). If the user chooses to print to a file (the only
 possibility on Windows and Mac OS), another dialog is given to
 select the filename.  If the user hits cancel in either of these
 dialogs, then @method[dc<%> ok?] returns @racket[#f].}
  如果@racket[interactive]为真，则会为用户提供一个用于设置打印参数的对话框（请参见@racket[get-ps-setup-from-user]）；结果配置将作为当前配置安装。如果用户选择打印到一个文件（在Windows和Mac OS上是唯一可能的），则会给出另一个对话框来选择文件名。如果用户在其中一个对话框中点击Cancel，那么@method[dc<%> ok?]返回@racket[#f]。

@;{If @racket[parent] is not @racket[#f], it is used as the parent window of
 the configuration dialog.}
  如果@racket[parent]不是@racket[#f]，它将用作配置对话框的父级窗口。

@;{If @racket[interactive] is @racket[#f], then the settings returned by
 @racket[current-ps-setup] are used. A file dialog is still presented
 to the user if the @method[ps-setup% get-file] method returns
 @racket[#f] and @racket[output] is @racket[#f], and the user may 
 hit @onscreen{Cancel} in that case so that @method[dc<%> ok?] returns @racket[#f].}
  如果@racket[interactive]为@racket[#f]，则使用@racket[current-ps-setup]返回的设置。如果@method[ps-setup% get-file]方法返回@racket[#f]并@racket[output]为@racket[#f]，则仍会向用户显示一个文件对话框，在这种情况下，用户可能会单击@onscreen{Cancel}，这样@method[dc<%> ok?]返回@racket[#f]。

@;{If @racket[use-paper-bbox] is @racket[#f], then the PostScript
 bounding box for the output is determined by @racket[width] and
 @racket[height] (which are rounded upward using @racket[ceiling]). 
 If @racket[use-paper-bbox] is not @racket[#f], then
 the bounding box is determined by the current paper size (as
 specified by @racket[current-ps-setup]). When @racket[width] or
 @racket[height] is @racket[#f], then the corresponding dimension is
 determined by the paper size, even if @racket[use-paper-bbox] is
 @racket[#f].}
 如果@racket[use-paper-bbox]为@racket[#f]，则输出的PostScript边界框由@racket[width]和@racket[height]确定（使用@racket[ceiling]向上取整）。如果@racket[use-paper-bbox]不是@racket[#f]，则边界框由当前纸张大小确定（由@racket[current-ps-setup]指定）。当@racket[width]或@racket[height]为@racket[#f]时，则相应的尺寸由纸张大小决定，即使@racket[use-paper-bbox]为@racket[#f]。 

@;{@index["Encapsulated PostScript (EPS)"]{If} @racket[as-eps] is
 @racket[#f], then the generated PostScript does not include an
 Encapsulated PostScript (EPS) header, and instead includes a generic
 PostScript header. The margin and translation factors specified by
 @racket[current-ps-setup] are used only when @racket[as-eps] is
 @racket[#f]. If @racket[as-eps] is true, then the generated
 PostScript includes a header that identifiers it as EPS.}
 @index["Encapsulated PostScript (EPS)"]{如果} @racket[as-eps]是@racket[#f]，则生成的PostScript不包含封装的PostScript（EPS）头，而是包含通用的PostScript头。只有当@racket[as-eps]为@racket[#f]时，才使用@racket[current-ps-setup]指定的边距和转换因子。如果@racket[as-eps]为真，则生成的PostScript包含一个标题，该标题将其标识为EPS。 

@;{When @racket[output] is not @racket[#f], then file-mode output is
 written to @racket[output]. If @racket[output] is @racket[#f], then
 the destination is determined via @racket[current-ps-setup] or by
 prompting the user for a pathname. When @racket[output] is a port,
 then data is written to @racket[port] by a thread that is created
 with the @racket[post-script-dc%] instance; in case that writing
 thread's custodian is shut down, calling @method[dc<%> end-doc]
 resumes the port-writing thread with @racket[thread-resume]
 and @racket[(current-thread)] as the second argument.}
  如果@racket[output]不是@racket[#f]，则文件模式输出写入@racket[output]。如果@racket[output]为@racket[#f]，则通过@racket[current-ps-setup]或提示用户输入路径名来确定目标。当@racket[output]为端口时，数据由@racket[post-script-dc%]实例创建的线程写入@racket[port]；如果关闭写入线程的保管器，则调用@method[dc<%> end-doc]以@racket[thread-resume]和@racket[(current-thread)]作为第二个参数恢复端口写入线程。

@;{See also @racket[ps-setup%] and @racket[current-ps-setup]. The
settings for a particular @racket[post-script-dc%] object are fixed to
the values in the current configuration when the object is created
(after the user has interactively adjusted them when
@racket[interactive] is true).}
 另请参见@racket[ps-setup%]和@racket[current-ps-setup]。创建对象时，特定@racket[post-script-dc%]对象的设置将固定为当前配置中的值（当@racket[interactive]为真时，用户交互式地调整了这些值之后）。 

}}
