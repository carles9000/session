@echo off
@cls
@set    path=c:\harbour\bin
@set include=c:\harbour\include

del session.hrb


@echo ========================
@echo Building Session.hrb
@echo ========================

harbour session.prg /n /w /gh

pause






