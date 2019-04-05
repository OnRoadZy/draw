#lang scribble/doc
@(require "common.rkt")

@defclass/title[gl-config% object% ()]{

@;{A @racket[gl-config%] object encapsulates configuration information
 for an OpenGL drawing context. Use a @racket[gl-config%] object as an
 initialization argument for @racket[canvas%] or provide it to
 @racket[make-gl-bitmap].}
  一个@racket[gl-config%]对象封装配置信息，用于一个OpenGL绘图上下文。使用@racket[gl-config%]对象作为@racket[canvas%]的一个初始化参数，或者提供给@racket[make-gl-bitmap]。

@defconstructor[()]{

@;{Creates a GL configuration that indicates legacy OpenGL, double
buffering, a depth buffer of size one, no stencil buffer, no
accumulation buffer, no multisampling, and not stereo.}
  创建一个GL配置，该配置指示旧的OpenGL、双缓冲、大小为1的深度缓冲、无模具缓冲、无累积缓冲、无多采样和无立体声。

}

@defmethod[(get-accum-size)
           (integer-in 0 256)]{

@;{Reports the accumulation-buffer size (for each of red, green, blue,
 and alpha) that the configuration requests, where zero means no
 accumulation buffer is requested.}
  报告配置请求的累积缓冲区大小（对于红、绿、蓝和alpha中的每一个），其中零表示不请求累积缓冲区。

}

@defmethod[(get-depth-size)
           (integer-in 0 256)]{

@;{Reports the depth-buffer size that the configuration requests, where
 zero means no depth buffer is requested.}
  报告配置请求的深度缓冲区大小，其中零表示没有请求深度缓冲区。

}

@defmethod[(get-double-buffered)
           boolean?]{

@;{Reports whether the configuration requests double buffering or not.}
  报告配置是否请求双缓冲。

}

@defmethod[(get-hires-mode)
           boolean?]{

@;{Determines whether to use hires mode. On Mac OS, hires mode means that the
created OpenGL contexts will have access to the full Retina resolution
and will not be scaled by the drawing system. On other platforms, hires mode
has no effect.}
  确定是否使用hires（雇用）模式。在Mac OS上，hires模式意味着创建的OpenGL上下文将能够访问完整的视网膜分辨率，并且不会被绘图系统缩放。在其他平台上，hires模式不起作用。

@history[#:added "1.5"]}


@defmethod[(get-legacy?)
           boolean?]{

@;{Determines whether to use legacy ``Compatibility'' OpenGL or ``Core'' OpenGL.
Core OpenGL profiles are currently supported on Mac OS (version 10.7 and up)
and Linux (if the graphics drivers support them).}
  确定是使用传统的“兼容性”OpenGL还是“核心”OpenGL。Mac OS（10.7及以上版本）和Linux（如果图形驱动程序支持）。目前支持核心OpenGL配置文件。

@history[#:added "1.2"]}

@defmethod[(get-multisample-size)
           (integer-in 0 256)]{

@;{Reports the multisampling size that the configuration requests, where
 zero means no multisampling is requested.}
  报告配置请求的多采样大小，其中零表示不请求多采样。

}

@defmethod[(get-share-context)
           (or/c #f (is-a?/c gl-context<%>))]{

@;{Returns a @racket[gl-context<%>] object that shares certain objects
(textures, display lists, etc.) with newly created OpenGL drawing
contexts, or @racket[#f] is none is set.}
返回与新创建的OpenGL绘图上下文共享某些对象（纹理、显示列表等）的@racket[gl-context<%>]对象，或者@racket[#f]表示没有设置。  

@;{See also @method[gl-config% set-share-context].}
  另请参见@method[gl-config% set-share-context]。

}
          

@defmethod[(get-stencil-size)
           (integer-in 0 256)]{

@;{Reports the stencil-buffer size that the configuration requests, where
 zero means no stencil buffer is requested.}
  报告配置请求的模具缓冲区大小，其中零表示没有请求模具缓冲区。

}

@defmethod[(get-stereo)
           boolean?]{

@;{Reports whether the configuration requests stereo or not.}
  报告配置是否请求立体声。

}

@defmethod[(get-sync-swap)
           boolean?]{

@;{Reports whether the configuration requests buffer-swapping
synchronization with the screen refresh.}
  报告配置是否请求与屏幕刷新进行缓冲区交换同步。

@history[#:added "1.10"]}

@defmethod[(set-accum-size [on? (integer-in 0 256)])
           void?]{

@;{Adjusts the configuration to request a particular accumulation-buffer
 size for every channel (red, green, blue, and alpha), where zero
 means no accumulation buffer is requested.}
  调整配置以请求每个通道（红、绿、蓝和alpha）的特定累积缓冲区大小，其中零表示不请求累积缓冲区。

}

@defmethod[(set-depth-size [on? (integer-in 0 256)])
           void?]{

@;{Adjusts the configuration to request a particular depth-buffer size,
 where zero means no depth buffer is requested.}
  调整配置以请求特定的深度缓冲区大小，其中零表示不请求深度缓冲区。

}

@defmethod[(set-double-buffered [on? any/c])
           void?]{

@;{Adjusts the configuration to request double buffering or not.}
  是否调整配置以请求双缓冲。

}

@defmethod[(set-hires-mode [hires-mode any/c])
           void?]{

@;{Adjusts the configuration to request hires mode or not; see
@method[gl-config get-hires-mode].}
  是否调整配置以请求租用模式；请参见@method[gl-config get-hires-mode]。

@history[#:added "1.5"]}

@defmethod[(set-legacy? [legacy? any/c])
           void?]{

@;{Adjusts the configuration to request legacy mode or not; see
@method[gl-config get-legacy?].}
  是否调整配置以请求传统模式；请参见@method[gl-config get-legacy?]

@history[#:added "1.2"]}


@defmethod[(set-multisample-size [on? (integer-in 0 256)])
           void?]{

@;{Adjusts the configuration to request a particular multisample size,
 where zero means no multisampling is requested. If a multisampling
 context is not available, this request will be ignored.}
  调整配置以请求特定的多采样大小，其中零表示不请求多采样。如果多采样上下文不可用，将忽略此请求。

}

@defmethod[(set-share-context [context (or/c #f (is-a?/c gl-context<%>))])
           void?]{

@;{Determines a @racket[gl-context<%>] object that shares certain objects
(textures, display lists, etc.) with newly created OpenGL drawing
contexts, where @racket[#f] indicates
that no sharing should occur.}
  确定与新创建的OpenGL绘图上下文共享某些对象（纹理、显示列表等）的@racket[gl-context<%>]对象，其中@racket[#f]表示不应发生共享。

@;{When a context @racket[_B] shares objects with context @racket[_A], it
is also shares objects with every other context sharing with
@racket[_A], and vice versa.}
  当上下文@racket[_B]与上下文@racket[_A]共享对象时，它也与与@racket[_A]共享其他所有上下文共享对象，反之亦然。

@;{If an OpenGL implementation does not support sharing, @racket[context]
is effectively ignored when a new context is created.
Sharing should be supported in all versions of Mac OS.
On Windows and Linux, sharing is provided by the presence of the
@tt{WGL_ARB_create_context} and @tt{GLX_ARB_create_context} extensions,
respectively (and OpenGL 3.2 requires both).}
  如果OpenGL实现不支持共享，则在创建新的上下文时，将有效地忽略上下文。所有版本的Mac OS都应该支持共享。在Windows和Linux上，共享是由@tt{WGL_ARB_create_context}和@tt{GLX_ARB_create_context}扩展分别提供的（而OpenGL3.2需要两者）。

}

@defmethod[(set-stencil-size [on? (integer-in 0 256)])
           void?]{

@;{Adjusts the configuration to request a particular stencil-buffer size,
 where zero means no stencil buffer is requested.}
  调整配置以请求特定的模具缓冲区大小，其中零表示不请求模具缓冲区。

}

@defmethod[(set-stereo [on? any/c])
           void?]{

@;{Adjusts the configuration to request stereo or not.}
  是否调整配置以请求立体声。
 }


@defmethod[(set-sync-swap [on? any/c])
           void?]{

@;{Adjusts the configuration to request buffer-swapping
synchronization with the screen refresh or not.}
  调整配置以请求是否与屏幕刷新进行缓冲区交换同步。

@history[#:added "1.10"]}

}
