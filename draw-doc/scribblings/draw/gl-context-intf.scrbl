#lang scribble/doc
@(require "common.rkt"
          (for-label (only-in ffi/unsafe cpointer?)))

@definterface/title[gl-context<%> ()]{

@;{A @racket[gl-context<%>] object represents a context for drawing with
 @as-index{OpenGL} to a specific @racket[dc<%>] instance. To obtain a
 @racket[gl-context<%>] object, call @method[dc<%> get-gl-context] of
 the target drawing context.}
@racket[gl-context<%>]对象表示使用@as-index{OpenGL}绘制到特定@racket[dc<%>]实例的上下文。要获取@racket[gl-context<%>]，请调用目标绘图上下文的@method[dc<%> get-gl-context]。

@;{Only canvas @racket[dc<%>] and @racket[bitmap-dc%] objects containing
 a bitmap from @racket[make-gl-bitmap] support OpenGL (always on
 Windows and Mac OS, sometimes on Unix).  Normal @racket[dc<%>]
 drawing and OpenGL drawing can be mixed in a @racket[bitmap-dc%], but
 a canvas that uses the @racket['gl] style to support OpenGL does not
 reliably support normal @racket[dc<%>] drawing; use a bitmap if you
 need to mix drawing modes, and use a canvas to maximize OpenGL
 performance.}
  只有画布@racket[dc<%>]和@racket[bitmap-dc%]对象包含@racket[make-gl-bitmap]中的位图，才支持OpenGL（始终在Windows和Mac OS上，有时在Unix上）。普通@racket[dc<%>]绘图和OpenGL绘图可以混合在@racket[bitmap-dc%]中，但使用@racket['gl]样式支持OpenGL的画布不可靠地支持普通@racket[dc<%>]绘图；如果需要混合绘图模式，请使用位图，并使用画布最大化OpenGL性能。

@;{When the target bitmap for a @racket[bitmap-dc%] context is changed
 via @method[bitmap-dc% set-bitmap], the associated
 @racket[gl-context<%>] changes. Canvas contexts are normally double
 buffered, and bitmap contexts are single buffered.}
  当@racket[bitmap-dc%]的目标位图通过@method[bitmap-dc% set-bitmap]更改时，关联的@racket[gl-context<%>]将更改。画布上下文通常是双缓冲的，位图上下文是单缓冲的。

@;{The @racketmodname[racket/gui/base] library provides no OpenGL
 routines. Instead, they must be obtained from a separate library,
 such as @racketmodname[sgl #:indirect]. The facilities in
 @racketmodname[racket/gui/base] merely manage the current OpenGL
 context, connecting it to windows and bitmaps.}
  @racketmodname[racket/gui/base]库不提供OpenGL例程。相反，它们必须从单独的库中获得，如@racketmodname[sgl #:indirect]。@racketmodname[racket/gui/base]中的工具只管理当前的OpenGL上下文，将其连接到Windows和位图。

@;{Only one OpenGL context can be active at a time across all threads and
 eventspaces. OpenGL contexts are not protected
 against interference among threads; that is, if a thread selects one
 of its OpenGL contexts, then other threads can write into the context
 via OpenGL commands. However, if all threads issue OpenGL commands
 only within a thunk passed to @method[gl-context<%> call-as-current],
 then drawing from the separate threads will not interfere, because
 @method[gl-context<%> call-as-current] uses a lock to serialize
 context selection across all threads in Racket.}
  在所有线程和事件空间中，一次只能有一个OpenGL上下文处于活动状态。OpenGL上下文不受线程间干扰的保护；也就是说，如果一个线程选择其OpenGL上下文之一，那么其他线程可以通过OpenGL命令写入上下文。但是，如果所有线程仅在传递给调用为当前线程的thunk内发出OpenGL命令，那么从单独的线程中进行绘制将不会产生干扰，因为调用为当前线程使用锁来序列化机架中所有线程的上下文选择。

@defmethod[(call-as-current [thunk (-> any)]
                            [alternate evt? never-evt]
                            [enable-breaks? any/c #f])
           any/c]{

@;{Calls a thunk with this OpenGL context as the current context for
 OpenGL commands.}
  使用此OpenGL上下文作为OpenGL命令的当前上下文调用thunk。

@;{The method blocks to obtain a lock that protects the global OpenGL
 context, and it releases the lock when the thunk returns or
 escapes. The lock is re-entrant, so a nested use of the method in the
 same thread with the same OpenGL context does not obtain or release
 the lock.}
  该方法阻止获取保护全局OpenGL上下文的锁，并在thunk返回或逸出时释放该锁。锁是可重入的，因此在具有相同OpenGL上下文的同一线程中嵌套使用该方法不会获取或释放锁。

@;{The lock prevents interference among OpenGL-using threads.  If a
 thread is terminated while holding the context lock, the lock is
 released. Continuation jumps into the thunk do not grab the lock or
 set the OpenGL context. See @racket[gl-context<%>] for more
 information on interference.}
  锁可以防止OpenGL使用线程之间的干扰。如果线程在保持上下文锁的同时终止，则释放该锁。继续跳到thunk中，不要获取锁或设置OpenGL上下文。有关干扰的详细信息，请参见@racket[gl-context<%>]。

@;{The method accepts an alternate @tech[#:doc
 reference-doc]{synchronizable event} for use while blocking for the
 context lock; see also @racket[sync].}
  方法接受一个备用的@tech[#:doc
 reference-doc]{可同步事件（synchronizable event）}，以便在为上下文锁阻塞时使用；另请参见@racket[sync]。

@;{The result of the method call is the result of the thunk if it is
 called, or the result of the alternate event if it is chosen instead
 of the context lock.}
 方法调用的结果是thunk（如果调用）的结果，或者如果选择替代事件（而不是上下文锁）的结果。 

@;{If @method[gl-context<%> ok?] returns @racket[#f] at the time that
 this method is called, then @|MismatchExn|.}
  在调用@method[gl-context<%> ok?]方法时如果此方法返回@racket[#f]，然后@|MismatchExn|。

@;{If @racket[enable-breaks?] is true, then the method uses
 @racket[sync/enable-break] while blocking for the context-setting
 lock instead of @racket[sync].}
  如果@racket[enable-breaks?]为真，则该方法在为上下文设置lock而不是@racket[sync]进行阻塞时使用@racket[sync/enable-break]。

}

@defmethod[(get-handle) cpointer?]{

@;{Returns a handle to the platform's underlying context. The value that the
pointer represents depends on the platform:}
  返回平台基础上下文的句柄。指针表示的值取决于平台：

@itemize[
@item{Windows: @tt{HGLRC}}
@item{Mac OS: @tt{NSOpenGLContext}}
@item{Unix: @tt{GLXContext}}
]

@;{Note that these values are not necessary the most ``low-level'' context objects,
but are instead the ones useful to Racket. For example, a @tt{NSOpenGLContext}
wraps a @tt{CGLContextObj}.}
  请注意，这些值不是最“底层”上下文对象所必需的，但是对Racket有用。例如，@tt{NSOpenGLContext}包装@tt{CGLContextObj}。
}

@defmethod[(ok?)
           boolean?]{

@;{Returns @racket[#t] if this context is available OpenGL drawing,
 @racket[#f] otherwise.}
  如果此上下文可用，则返回 @racket[#t]；否则返回@racket[#f]。

@;{A context is unavailable if OpenGL support is disabled at compile time
 or run time, if the context is associated with a
 @racket[bitmap-dc%] with no selected bitmap or with a monochrome
 selected bitmap, if the context is for a canvas that no longer
 exists, or if there was a low-level error when preparing the context.}
  如果在编译时或运行时禁用OpenGL支持，或者上下文与没有选定位图的@racket[bitmap-dc%]关联，或者与单色选定位图关联，或者上下文用于不再存在的画布，或者在准备上下文时出现低级错误，则上下文不可用。

}

@defmethod[(swap-buffers)
           void?]{

@;{Swaps the front (visible) and back (OpenGL-drawing) buffer for a
 context associated with a canvas, and has no effect on a bitmap
 context.}
  为与画布关联的上下文交换前（可见）和后（OpenGL绘图）缓冲区，并且对位图上下文没有影响。

@;{This method implicitly uses @method[gl-context<%> call-as-current] to
 obtain the context lock. Since the lock is re-entrant, however, the
 @method[gl-context<%> swap-buffers] method can be safely used within
 a @method[gl-context<%> call-as-current] thunk.}
  此方法隐式使用@method[gl-context<%> call-as-current]获取上下文锁。但是，由于锁是可重入的，因此可以在调用中安全地使用@method[gl-context<%> swap-buffers]方法作为@method[gl-context<%> call-as-current]的thunk。

}}

@;{@defproc[(get-current-gl-context) gl-context<%>]{
If within the dynamic extent of a @method[gl-context<%> call-as-current]
method call, returns the current context; otherwise returns @racket[#f].
This is possibly most useful for caching context-dependent state or data,
such as extension strings. Create such caches using @racket[make-weak-hasheq].}
如果在作为@method[gl-context<%> call-as-current]的动态范围内，则返回当前上下文；否则返回@racket[#f]。这对于缓存依赖于上下文的状态或数据（如扩展字符串）可能最有用。使用@racket[make-weak-hasheq]创建此类缓存。

@history[#:added "1.3"]
}
