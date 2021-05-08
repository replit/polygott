# assembly


echo "c2VjdGlvbiAudGV4dApnbG9iYWwgX3N0YXJ0Cl9zdGFydDoKbW92IHJheCwgMQptb3YgcmRpLCAxCm1vdiByc2ksIGJ1Zgptb3YgcmR4LCA1CnN5c2NhbGwKbW92IHJheCwgNjAKeG9yIHJkaSwgcmRpCnN5c2NhbGwKc2VjdGlvbiAuZGF0YQpidWY6IGRiICJoZWxsbyI="  | base64 --decode | docker run --rm -i polygott run-project -s -l assembly | diff -u --label "assembly" <( echo "aGVsbG8=" | base64 --decode ) - && echo ✓ assembly:hello


# java


echo "Y2xhc3MgTWFpbiB7IHB1YmxpYyBzdGF0aWMgdm9pZCBtYWluKFN0cmluZ1tdIGFyZ3MpIHsgU3lzdGVtLm91dC5wcmludGxuKCJoZWxsbyIpOyB9IH0="  | base64 --decode | docker run --rm -i polygott run-project -s -l java | diff -u --label "java" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ java:hello


# ballerina


echo "aW1wb3J0IGJhbGxlcmluYS9pbzsKcHVibGljIGZ1bmN0aW9uIG1haW4oKSB7CiAgICBpbzpwcmludGxuKCJIZWxsbywgV29ybGQhIik7Cn0K"  | base64 --decode | docker run --rm -i polygott run-project -s -l ballerina | diff -u --label "ballerina" <( echo "SGVsbG8sIFdvcmxkIQo=" | base64 --decode ) - && echo ✓ ballerina:hello


# bash


echo "ZWNobyBoZWxsbw=="  | base64 --decode | docker run --rm -i polygott run-project -s -l bash | diff -u --label "bash" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ bash:hello


# c


echo "I2luY2x1ZGUgInN0ZGlvLmgiCmludCBtYWluKHZvaWQpIHsKcHJpbnRmKCJoZWxsb1xuIik7CnJldHVybiAwOwp9"  | base64 --decode | docker run --rm -i polygott run-project -s -l c | diff -u --label "c" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ c:hello


# common lisp


echo "KGZvcm1hdCB0ICJIZWxsbywgd29ybGQhIik="  | base64 --decode | docker run --rm -i polygott run-project -s -l clisp | diff -u --label "common lisp" <( echo "SGVsbG8sIHdvcmxkIQ==" | base64 --decode ) - && echo ✓ common lisp:hello


# clojure


echo "KHByaW50bG4gImhlbGxvIik="  | base64 --decode | docker run --rm -i polygott run-project -s -l clojure | diff -u --label "clojure" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ clojure:hello


# cpp


echo "I2luY2x1ZGUgPGlvc3RyZWFtPgppbnQgbWFpbigpIHsgc3RkOjpjb3V0IDw8ICJoZWxsbyIgPDwgc3RkOjplbmRsOyB9"  | base64 --decode | docker run --rm -i polygott run-project -s -l cpp | diff -u --label "cpp" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ cpp:hello


# cpp11


echo "I2luY2x1ZGUgPGlvc3RyZWFtPgppbnQgbWFpbigpIHsgc3RkOjpjb3V0IDw8ICJoZWxsbyIgPDwgc3RkOjplbmRsOyB9"  | base64 --decode | docker run --rm -i polygott run-project -s -l cpp11 | diff -u --label "cpp11" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ cpp11:hello


# crystal


echo "cHV0cyAiaGVsbG8gd29ybGQi"  | base64 --decode | docker run --rm -i polygott run-project -s -l crystal | diff -u --label "crystal" <( echo "aGVsbG8gd29ybGQK" | base64 --decode ) - && echo ✓ crystal:hello


# csharp


echo "dXNpbmcgU3lzdGVtOyBjbGFzcyBNYWluQ2xhc3MgeyBwdWJsaWMgc3RhdGljIHZvaWQgTWFpbiAoc3RyaW5nW10gYXJncykgeyBDb25zb2xlLldyaXRlTGluZSAoImhlbGxvIik7IH0gfQ=="  | base64 --decode | docker run --rm -i polygott run-project -s -l csharp | diff -u --label "csharp" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ csharp:hello


# D


echo "aW1wb3J0IHN0ZC5zdGRpbzogd3JpdGVsbjt2b2lkIG1haW4oKXt3cml0ZWxuKCJoZWxsbyIpO30="  | base64 --decode | docker run --rm -i polygott run-project -s -l d | diff -u --label "D" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ D:hello


# dart


echo "dm9pZCBtYWluKCkgeyBwcmludCgnSGVsbG8sIFdvcmxkIScpOyB9"  | base64 --decode | docker run --rm -i polygott run-project -s -l dart | diff -u --label "dart" <( echo "SGVsbG8sIFdvcmxkIQo=" | base64 --decode ) - && echo ✓ dart:hello


# deno


echo "Y29uc29sZS5sb2coImhlbGxvIik="  | base64 --decode | docker run --rm -i polygott run-project -s -l deno | diff -u --label "deno" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ deno:hello


# elisp


echo "KHByaW5jIChmb3JtYXQgIjIgKyAyID0gJWRcbiIgKCsgMiAyKSkpCg=="  | base64 --decode | docker run --rm -i polygott run-project -s -l elisp | diff -u --label "elisp" <( echo "MiArIDIgPSA0Cg==" | base64 --decode ) - && echo ✓ elisp:math


# erlang


echo "LW1vZHVsZShtYWluKS4KLWV4cG9ydChbc3RhcnQvMF0pLgoKc3RhcnQoKSAtPgogIGlvOmZ3cml0ZSgiaGVsbG8gd29ybGQKIiku"  | base64 --decode | docker run --rm -i polygott run-project -s -l erlang | diff -u --label "erlang" <( echo "aGVsbG8gd29ybGQK" | base64 --decode ) - && echo ✓ erlang:hello


# elixir


echo "SU8ucHV0cyAiaGVsbG8gd29ybGQi"  | base64 --decode | docker run --rm -i polygott run-project -s -l elixir | diff -u --label "elixir" <( echo "aGVsbG8gd29ybGQK" | base64 --decode ) - && echo ✓ elixir:hello


# nodejs


echo "Y29uc29sZS5sb2coImhlbGxvIik="  | base64 --decode | docker run --rm -i polygott run-project -s -l nodejs | diff -u --label "nodejs" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ nodejs:hello


# enzyme


echo "Y29uc29sZS5sb2coImhlbGxvIik="  | base64 --decode | docker run --rm -i polygott run-project -s -l enzyme | diff -u --label "enzyme" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ enzyme:hello


# express


echo "Y29uc29sZS5sb2coImhlbGxvIik="  | base64 --decode | docker run --rm -i polygott run-project -s -l express | diff -u --label "express" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ express:hello


# flow

# forth


echo "LiIgaGVsbG8iIENS"  | base64 --decode | docker run --rm -i polygott run-project -s -l forth | diff -u --label "forth" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ forth:hello


# fortran


echo "cHJvZ3JhbSBtYWluCnByaW50ICcoImhlbGxvIiknCmVuZCBwcm9ncmFtIG1haW4="  | base64 --decode | docker run --rm -i polygott run-project -s -l fortran | diff -u --label "fortran" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ fortran:hello


# fsharp


echo "U3lzdGVtLkNvbnNvbGUuV3JpdGVMaW5lKCJoZWxsbyIp"  | base64 --decode | docker run --rm -i polygott run-project -s -l fsharp | diff -u --label "fsharp" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ fsharp:hello


# gatsbyjs

# go


echo "cGFja2FnZSBtYWluIAppbXBvcnQgImZtdCIgCmZ1bmMgbWFpbigpIHsgCmZtdC5QcmludGxuKCJoZWxsbyIpIAp9"  | base64 --decode | docker run --rm -i polygott run-project -s -l go | diff -u --label "go" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ go:hello



echo "cGFja2FnZSBtYWluIAppbXBvcnQgKCJmbXQiIAoicnVudGltZSIpIApmdW5jIG1haW4oKXtmbXQuUHJpbnQocnVudGltZS5WZXJzaW9uKClbOjddKX0="  | base64 --decode | docker run --rm -i polygott run-project -s -l go | diff -u --label "go" <( echo "Z28xLjE0Lg==" | base64 --decode ) - && echo ✓ go:version


# guile


echo "KGRpc3BsYXkgImhlbGxvIHdvcmxkIik="  | base64 --decode | docker run --rm -i polygott run-project -s -l guile | diff -u --label "guile" <( echo "aGVsbG8gd29ybGQ=" | base64 --decode ) - && echo ✓ guile:hello


# haskell


echo "bWFpbiA9IHB1dFN0ckxuICJoZWxsbyI="  | base64 --decode | docker run --rm -i polygott run-project -s -l haskell | diff -u --label "haskell" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ haskell:hello


# haxe


echo "Y2xhc3MgTWFpbiB7CglzdGF0aWMgZnVuY3Rpb24gbWFpbigpIHsKCQl0cmFjZSgiSGVsbG8sIHdvcmxkISIpOwoJfQp9"  | base64 --decode | docker run --rm -i polygott run-project -s -l haxe | diff -u --label "haxe" <( echo "TWFpbi5oeDozOiBIZWxsbywgd29ybGQhCg==" | base64 --decode ) - && echo ✓ haxe:hello


# jest

# julia


echo "cHJpbnRsbigiaGVsbG8iKQ=="  | base64 --decode | docker run --rm -i polygott run-project -s -l julia | diff -u --label "julia" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ julia:hello


# kotlin


echo S kotlin:hello


# love2d


echo S love2d:hello


# lua


echo "cHJpbnQoImhlbGxvIik="  | base64 --decode | docker run --rm -i polygott run-project -s -l lua | diff -u --label "lua" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ lua:hello


# mercury


echo "Oi0gbW9kdWxlIG1haW4uCjotIGludGVyZmFjZS4KOi0gaW1wb3J0X21vZHVsZSBpby4KOi0gcHJlZAogIG1haW4oaW86OmRpLCBpbzo6dW8pIGlzIGRldC4KOi0gaW1wbGVtZW50YXRpb24uCm1haW4oIUlPKSA6LQogaW8ud3JpdGVfc3RyaW5nKCJoZWxsbyB3b3JsZAoiLCAhSU8pLg=="  | base64 --decode | docker run --rm -i polygott run-project -s -l mercury | diff -u --label "mercury" <( echo "aGVsbG8gd29ybGQK" | base64 --decode ) - && echo ✓ mercury:hello


# nextjs

# nim


echo "ZWNobyAiaGVsbG8gd29ybGQi"  | base64 --decode | docker run --rm -i polygott run-project -s -l nim | diff -u --label "nim" <( echo "Q0M6IHN0ZGxpYl9pby5uaW0KQ0M6IHN0ZGxpYl9zeXN0ZW0ubmltCkNDOiBtYWluLm5pbQpoZWxsbyB3b3JsZAo=" | base64 --decode ) - && echo ✓ nim:hello


# nix


echo "ZWNobyAneyBwa2dzIH06IHsgZGVwcyA9IFsgcGtncy5weXRob24zOSBdOyB9JyA+IHJlcGxpdC5uaXgKbml4LXNoZWxsIC0tYXJnc3RyIHJlcGxkaXIgIiRQV0QiIC9vcHQvbml4cHJveHkubml4IC0tY29tbWFuZCAicHl0aG9uIC0tdmVyc2lvbiIKCg=="  | base64 --decode | docker run --rm -i polygott run-project -s -l nix | diff -u --label "nix" <( echo "UHl0aG9uIDMuOS40Cg==" | base64 --decode ) - && echo ✓ nix:hello


# objective-c


echo "I2ltcG9ydCA8b2JqYy9vYmpjLmg+CiNpbXBvcnQgPG9iamMvT2JqZWN0Lmg+CiNpbXBvcnQgPEZvdW5kYXRpb24vRm91bmRhdGlvbi5oPgppbnQgbWFpbih2b2lkKSB7CglAYXV0b3JlbGVhc2Vwb29sIHsKCQlOU1N0cmluZyogc3RyID0gQCJIZWxsbyBmcm9tIE9iamVjdGl2ZS1DIDIuMCEiOwoJCXB1dHMoW3N0ciBjU3RyaW5nXSk7Cgl9CglyZXR1cm4gMDsKfQo="  | base64 --decode | docker run --rm -i polygott run-project -s -l objective-c | diff -u --label "objective-c" <( echo "SGVsbG8gZnJvbSBPYmplY3RpdmUtQyAyLjAhCg==" | base64 --decode ) - && echo ✓ objective-c:hello


# ocaml


echo "cHJpbnRfc3RyaW5nICJoZWxsbyB3b3JsZCEKIjs7"  | base64 --decode | docker run --rm -i polygott run-project -s -l ocaml | diff -u --label "ocaml" <( echo "aGVsbG8gd29ybGQhCg==" | base64 --decode ) - && echo ✓ ocaml:hello


# pascal


echo "cHJvZ3JhbSBoZWxsbzsKYmVnaW4KCXdyaXRlbG4oJ2hlbGxvIHdvcmxkJyk7CmVuZC4="  | base64 --decode | docker run --rm -i polygott run-project -s -l pascal | diff -u --label "pascal" <( echo "aGVsbG8gd29ybGQK" | base64 --decode ) - && echo ✓ pascal:hello


# php


echo "PD9waHAgZWNobyAiaGVsbG8KIjs="  | base64 --decode | docker run --rm -i polygott run-project -s -l php | diff -u --label "php" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ php:hello


# powershell


echo "JHN0clN0cmluZyA9ICJIZWxsbyBXb3JsZCI7IHdyaXRlLWhvc3QgJHN0clN0cmluZw=="  | base64 --decode | docker run --rm -i polygott run-project -s -l powershell | diff -u --label "powershell" <( echo "SGVsbG8gV29ybGQK" | base64 --decode ) - && echo ✓ powershell:hello


# prolog


echo "Oi0gaW5pdGlhbGl6YXRpb24obWFpbikuCm1haW4gOi0gd3JpdGUoJ2hlbGxvLCB3b3JsZFxuJyku"  | base64 --decode | docker run --rm -i polygott run-project -s -l prolog | diff -u --label "prolog" <( echo "aGVsbG8sIHdvcmxkCg==" | base64 --decode ) - && echo ✓ prolog:hello


# python3


echo "cHJpbnQoX19uYW1lX18p"  | base64 --decode | docker run --rm -i polygott run-project -s -l python3 | diff -u --label "python3" <( echo "X19tYWluX18K" | base64 --decode ) - && echo ✓ python3:0



echo "cHJpbnQoImhlbGxvIik="  | base64 --decode | docker run --rm -i polygott run-project -s -l python3 | diff -u --label "python3" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ python3:hello



echo "aW1wb3J0IHN5czsgcHJpbnQoc3lzLnZlcnNpb24uc3RhcnRzd2l0aCgnMy44Jykp"  | base64 --decode | docker run --rm -i polygott run-project -s -l python3 | diff -u --label "python3" <( echo "VHJ1ZQo=" | base64 --decode ) - && echo ✓ python3:version


# pygame


echo "cHJpbnQoX19uYW1lX18p"  | base64 --decode | docker run --rm -i polygott run-project -s -l pygame | diff -u --label "pygame" <( echo "X19tYWluX18K" | base64 --decode ) - && echo ✓ pygame:0



echo "cHJpbnQoImhlbGxvIik="  | base64 --decode | docker run --rm -i polygott run-project -s -l pygame | diff -u --label "pygame" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ pygame:hello


# python


echo "cHJpbnQgImhlbGxvIg=="  | base64 --decode | docker run --rm -i polygott run-project -s -l python | diff -u --label "python" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ python:hello


# pyxel


echo "cHJpbnQoX19uYW1lX18p"  | base64 --decode | docker run --rm -i polygott run-project -s -l pyxel | diff -u --label "pyxel" <( echo "X19tYWluX18K" | base64 --decode ) - && echo ✓ pyxel:0



echo "cHJpbnQoImhlbGxvIik="  | base64 --decode | docker run --rm -i polygott run-project -s -l pyxel | diff -u --label "pyxel" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ pyxel:hello



echo "aW1wb3J0IHB5eGVs"  | base64 --decode | docker run --rm -i polygott run-project -s -l pyxel | diff -u --label "pyxel" <( echo "Cg==" | base64 --decode ) - && echo ✓ pyxel:pyxel


# quil

# raku


echo "c2F5ICdoZWxsbyB3b3JsZCc7"  | base64 --decode | docker run --rm -i polygott run-project -s -l raku | diff -u --label "raku" <( echo "aGVsbG8gd29ybGQK" | base64 --decode ) - && echo ✓ raku:hello


# react_native

# reactjs

# reactts

# rlang


echo "cHJpbnQoIkhlbGxvIFdvcmxkIik="  | base64 --decode | docker run --rm -i polygott run-project -s -l rlang | diff -u --label "rlang" <( echo "WzFdICJIZWxsbyBXb3JsZCIK" | base64 --decode ) - && echo ✓ rlang:hello


# ruby


echo "cHV0cyAiaGVsbG8i"  | base64 --decode | docker run --rm -i polygott run-project -s -l ruby | diff -u --label "ruby" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ ruby:hello


# rust


echo "Zm4gbWFpbigpIHsKICBwcmludGxuISgiaGVsbG8iKTsKfQ=="  | base64 --decode | docker run --rm -i polygott run-project -s -l rust | diff -u --label "rust" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ rust:hello


# scala


echo "b2JqZWN0IE1haW4geyBkZWYgbWFpbihhcmdzOiBBcnJheVtTdHJpbmddKSB7IHByaW50bG4oIkhlbGxvLCB3b3JsZCEiKSB9IH0K"  | base64 --decode | docker run --rm -i polygott run-project -s -l scala | diff -u --label "scala" <( echo "SGVsbG8sIHdvcmxkIQo=" | base64 --decode ) - && echo ✓ scala:hello


# sqlite


echo "c2VsZWN0ICdoZWxsbyc7"  | base64 --decode | docker run --rm -i polygott run-project -s -l sqlite | diff -u --label "sqlite" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ sqlite:hello


# swift


echo "cHJpbnQoImhlbGxvIik="  | base64 --decode | docker run --rm -i polygott run-project -s -l swift | diff -u --label "swift" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ swift:hello


# tcl


echo "cHV0cyB7aGVsbG99"  | base64 --decode | docker run --rm -i polygott run-project -s -l tcl | diff -u --label "tcl" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ tcl:hello


# WebAssembly


echo "Ozsgd2F0Mndhc20gbWFpbi53YXQKCihtb2R1bGUgJGhlbGxvCiAgICA7OyBJbXBvcnQgdGhlIHJlcXVpcmVkIGZkX3dyaXRlIFdBU0kgZnVuY3Rpb24gd2hpY2ggd2lsbCB3cml0ZSB0aGUgZ2l2ZW4gaW8gdmVjdG9ycyB0byBzdGRvdXQKICAgIDs7IFRoZSBmdW5jdGlvbiBzaWduYXR1cmUgZm9yIGZkX3dyaXRlIGlzOgogICAgOzsgKEZpbGUgRGVzY3JpcHRvciwgKmlvdnMsIGlvdnNfbGVuLCBud3JpdHRlbikgLT4gUmV0dXJucyBudW1iZXIgb2YgYnl0ZXMgd3JpdHRlbgogICAgKGltcG9ydCAid2FzaV91bnN0YWJsZSIgImZkX3dyaXRlIgogICAgICAgIChmdW5jICRmZF93cml0ZSAocGFyYW0gaTMyIGkzMiBpMzIgaTMyKSAocmVzdWx0IGkzMikpCiAgICApCgogICAgKG1lbW9yeSAxKQogICAgKGV4cG9ydCAibWVtb3J5IiAobWVtb3J5IDApKQoKICAgIDs7IFdyaXRlICdoZWxsbyB3b3JsZFxuJyB0byBtZW1vcnkgYXQgYW4gb2Zmc2V0IG9mIDggYnl0ZXMKICAgIDs7IE5vdGUgdGhlIHRyYWlsaW5nIG5ld2xpbmUgd2hpY2ggaXMgcmVxdWlyZWQgZm9yIHRoZSB0ZXh0IHRvIGFwcGVhcgogICAgKGRhdGEgKGkzMi5jb25zdCA4KSAiSGVsbG8sIFdvcmxkIikKCiAgICAoZnVuYyAkbWFpbiAoZXhwb3J0ICJfc3RhcnQiKQogICAgICAgIDs7IENyZWF0aW5nIGEgbmV3IGlvIHZlY3RvciB3aXRoaW4gbGluZWFyIG1lbW9yeQogICAgICAgIChpMzIuc3RvcmUgKGkzMi5jb25zdCAwKSAoaTMyLmNvbnN0IDgpKSAgOzsgaW92Lmlvdl9iYXNlIC0gVGhpcyBpcyBhIHBvaW50ZXIgdG8gdGhlIHN0YXJ0IG9mIHRoZSAnaGVsbG8gd29ybGRcbicgc3RyaW5nCiAgICAgICAgKGkzMi5zdG9yZSAoaTMyLmNvbnN0IDQpIChpMzIuY29uc3QgMTIpKSAgOzsgaW92Lmlvdl9sZW4gLSBUaGUgbGVuZ3RoIG9mIHRoZSAnaGVsbG8gd29ybGRcbicgc3RyaW5nCgogICAgICAgIChjYWxsICRmZF93cml0ZQogICAgICAgICAgICAoaTMyLmNvbnN0IDEpIDs7IGZpbGVfZGVzY3JpcHRvciAtIDEgZm9yIHN0ZG91dAogICAgICAgICAgICAoaTMyLmNvbnN0IDApIDs7ICppb3ZzIC0gVGhlIHBvaW50ZXIgdG8gdGhlIGlvdiBhcnJheSwgd2hpY2ggaXMgc3RvcmVkIGF0IG1lbW9yeSBsb2NhdGlvbiAwCiAgICAgICAgICAgIChpMzIuY29uc3QgMSkgOzsgaW92c19sZW4gLSBXZSdyZSBwcmludGluZyAxIHN0cmluZyBzdG9yZWQgaW4gYW4gaW92IC0gc28gb25lLgogICAgICAgICAgICAoaTMyLmNvbnN0IDIwKSA7OyBud3JpdHRlbiAtIEEgcGxhY2UgaW4gbWVtb3J5IHRvIHN0b3JlIHRoZSBudW1iZXIgb2YgYnl0ZXMgd3JpdGVuCiAgICAgICAgKQogICAgICAgIGRyb3AgOzsgRGlzY2FyZCB0aGUgbnVtYmVyIG9mIGJ5dGVzIHdyaXR0ZW4gZnJvbSB0aGUgdG9wIHRoZSBzdGFjawogICAgKQopCg=="  | base64 --decode | docker run --rm -i polygott run-project -s -l webassembly | diff -u --label "WebAssembly" <( echo "SGVsbG8sIFdvcmxk" | base64 --decode ) - && echo ✓ WebAssembly:hello


# wren


echo "U3lzdGVtLnByaW50KCJoZWxsbyIp"  | base64 --decode | docker run --rm -i polygott run-project -s -l wren | diff -u --label "wren" <( echo "aGVsbG8K" | base64 --decode ) - && echo ✓ wren:hello


