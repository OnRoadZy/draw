#lang scribble/doc
@(require "common.rkt")

@defclass/title[record-dc% object% (dc<%>)]{

@;{A @racket[record-dc%] object records drawing actions for replay into
 another drawing context. The recorded drawing operations can be
 extracted as a procedure via @method[record-dc%
 get-recorded-procedure], or the actions can be extracted as a datum
 (that can be printed with @racket[write] and recreated with
 @racket[read]) via @method[record-dc% get-recorded-datum].}
  @racket[record-dc%]对象记录绘图操作以重放到其他绘图上下文中。记录的绘图操作可以通过@method[record-dc%
 get-recorded-procedure]过程提取为一个过程，也可以通过@method[record-dc% get-recorded-datum]数据提取为一个数据（可以用@racket[write]打印并用@racket[read]重新创建）。

@;{When drawing recorded actions, the target drawing context's pen,
brush, font, text, background, text background, and text foreground do
not affect the recorded actions. The target drawing context's
transformation, alpha, and clipping region compose with settings in
the recorded actions (so that, for example, a recorded action to set
the clipping region actually intersects the region with the drawing
context's clipping region at the time that the recorded commands are
replayed). After recoded commands are replayed, all settings in the
target drawing context, such as its clipping region or current font,
are as before the replay.}
绘制录制的操作时，目标绘图上下文的笔、画笔、字体、文本、背景、文本背景和文本前景不会影响录制的操作。目标图形上下文的转换、alpha和剪切区域使用录制操作中的设置进行组合（例如，设置剪切区域的录制操作实际上会在重放录制的命令时与图形上下文的剪切区域相交）。重播重新编码的命令后，目标图形上下文中的所有设置（如剪切区域或当前字体）都与重播前相同。

@defconstructor[([width (>=/c 0) 640]
                 [height (>=/c 0) 480])]{

@;{Creates a new recording DC. The optional @racket[width] and
 @racket[height] arguments determine the result of @method[dc<%>
 get-size] on the recording DC; the @racket[width] and
 @racket[height] arguments do not clip drawing.}
  创建新的录制DC。可选的@racket[width]和@racket[height]参数决定了在记录@method[dc<%>
 get-size]的结果；@racket[width]和@racket[height]参数不剪辑绘图。
  }


@defmethod[(get-recorded-datum) any/c]{

@;{Extracts a recorded drawing to a value that can be printed with
@racket[write] and re-read with @racket[read]. Use
@racket[recorded-datum->procedure] to convert the datum to a drawing
procedure.}
  将记录的绘图提取到一个值，该值可以用@racket[write]打印，也可以用@racket[read]重新读取。使用@racket[recorded-datum->procedure]将基准转换为绘图程序。
  }


@defmethod[(get-recorded-procedure) ((is-a?/c dc<%>) . -> . void?)]{

@;{Extracts a recorded drawing to a procedure that can be applied to
another DC to replay the drawing commands to the given DC.}
  将记录的绘图提取到可应用于其他DC的过程中，以便将绘图命令重放到给定DC。

@;{The @method[record-dc% get-recorded-procedure] method can be more
efficient than composing @method[record-dc% get-recorded-datum] and
@racket[recorded-datum->procedure].}
@method[record-dc% get-recorded-procedure]方法比@method[record-dc% get-recorded-datum]和@racket[recorded-datum->procedure]的合成方法更有效。
}}
