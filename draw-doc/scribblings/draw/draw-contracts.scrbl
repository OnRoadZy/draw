#lang scribble/doc
@(require "common.rkt")

@;{@title{Drawing Contracts}}
@title[#:tag "drawing-contracts"]{绘图合约}

@local-table-of-contents[]

@;{This page documents the contracts that are used to describe
the specification of @racketmodname[racket/draw] objects
and functions.}
本页记录了用于描述@racketmodname[racket/draw]对象和函数的规范的合同。

@defthing[font-family/c flat-contract?]{
 @;{Recognizes font designations. Corresponds to the @racket[_family]
  initialization argument of the @racket[font%] class.}
 识别字体名称。对应于@racket[font%]类的@racket[_family]初始化参数。

  @;{Equivalent to the following definition:}
   相当于以下定义： 
  @racketblock[
    (or/c 'default 'decorative 'roman 'script 'swiss
          'modern 'symbol 'system)]
}

@defthing[font-style/c flat-contract?]{
  @;{Recognizes font styles. Corresponds to the @racket[_style]
  initialization argument of the @racket[font%] class.}
    识别字体样式。对应于@racket[font%]类的@racket[_style]初始化参数。

  @;{Equivalent to the following definition:}
    相当于以下定义：
  @racketblock[(or/c 'normal 'italic 'slant)]
}

@defthing[font-weight/c flat-contract?]{
  @;{Recognizes @tech{font weights}. Corresponds to the @racket[_weight]
  initialization argument of the @racket[font%] class.}
    识别@tech{字体粗细（font weights）}。对应于@racket[font%]类的@racket[_weight]初始化参数。
}

@defthing[font-smoothing/c flat-contract?]{
  @;{Recognizes a font smoothing amount.
  Corresponds to the @racket[_smoothing]
  initialization argument of the @racket[font%] class.}
    识别字体平滑量。对应于@racket[font%]类的@racket[_smoothing]初始化参数。

  @;{Equivalent to the following definition:}
    相当于以下定义：
  @racketblock[(or/c 'default 'partly-smoothed
                     'smoothed 'unsmoothed)]
}

@defthing[font-hinting/c flat-contract?]{
  @;{Recognizes font hinting modes. Corresponds to the @racket[_hinting]
  initialization argument of the @racket[font%] class.}
    识别字体提示模式。对应于@racket[font%]类的@racket[_hinting]初始化参数。

  @;{Equivalent to the following definition:}
    相当于以下定义：
  @racketblock[(or/c 'aligned 'unaligned)]
}

@defthing[pen-style/c flat-contract?]{
  @;{Recognizes pen styles. Corresponds
  to the @racket[_style] initialization argument of the
  @racket[pen%] class.}
识别笔样式。对应于@racket[pen%]类的@racket[_style]初始化参数。

  @;{Equivalent to the following definition:}
    相当于以下定义：
  @racketblock[
  (or/c 'transparent 'solid 'xor 'hilite
        'dot 'long-dash 'short-dash 'dot-dash
        'xor-dot 'xor-long-dash 'xor-short-dash
        'xor-dot-dash)]
}

@defthing[pen-cap-style/c flat-contract?]{
  @;{Recognizes pen cap styles. Corresponds
  to the @racket[_cap] initialization argument of the
  @racket[pen%] class.}
    识别笔帽样式。对应于@racket[pen%]类的@racket[_cap]初始化参数。
    
  @;{Equivalent to the following definition:}
    相当于以下定义：
  @racketblock[(or/c 'round 'projecting 'butt)]
}

@defthing[pen-join-style/c flat-contract?]{
  @;{Recognizes pen join styles. Corresponds
  to the @racket[_join] initialization argument of the
  @racket[pen%] class.}
    识别笔连接样式。对应于@racket[pen%]类的@racket[_join]初始化参数。

  @;{Equivalent to the following definition:}
    相当于以下定义：
  @racketblock[(or/c 'round 'bevel 'miter)]
}

@defthing[brush-style/c flat-contract?]{
  @;{Recognizes brush styles. Corresponds
  to the @racket[_style] initialization argument of the
  @racket[brush%] class.}
    识别画笔类型。对应于@racket[brush%]类的@racket[_style]初始化参数。

  @;{Equivalent to the following definition:}
    相当于以下定义：
  @racketblock[
  (or/c 'transparent 'solid 'opaque
        'xor 'hilite 'panel
        'bdiagonal-hatch 'crossdiag-hatch
        'fdiagonal-hatch 'cross-hatch
        'horizontal-hatch 'vertical-hatch)]
}

