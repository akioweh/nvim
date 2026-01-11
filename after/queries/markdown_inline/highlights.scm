;; extends

;; conceals the backslash of simple escape sequences
;; e.g. \[ becomes [


((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\[")
 (#set! conceal "["))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\]")
 (#set! conceal "]"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\(")
 (#set! conceal "("))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\)")
 (#set! conceal ")"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\{")
 (#set! conceal "{"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\}")
 (#set! conceal "}"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\*")
 (#set! conceal "*"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\_")
 (#set! conceal "_"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\-")
 (#set! conceal "-"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\`")
 (#set! conceal "`"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\#")
 (#set! conceal "#"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\\\")
 (#set! conceal "\\"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\.")
 (#set! conceal "."))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\!")
 (#set! conceal "!"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\\"")
 (#set! conceal "\""))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\$")
 (#set! conceal "$"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\%")
 (#set! conceal "%"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\&")
 (#set! conceal "&"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\'")
 (#set! conceal "'"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\+")
 (#set! conceal "+"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\,")
 (#set! conceal ","))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\/")
 (#set! conceal "/"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\:")
 (#set! conceal ":"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\;")
 (#set! conceal ";"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\<")
 (#set! conceal "<"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\>")
 (#set! conceal ">"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\=")
 (#set! conceal "="))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\?")
 (#set! conceal "?"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\@")
 (#set! conceal "@"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\^")
 (#set! conceal "^"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\|")
 (#set! conceal "|"))

((backslash_escape) @conceal.escape
 (#eq? @conceal.escape "\\~")
 (#set! conceal "~"))
