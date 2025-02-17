; RUN: llc %s -o - -mtriple=aarch64-unknown -mattr=+fuse-adrp-add | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=generic         | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=cortex-a53      | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=cortex-a55      | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=cortex-a510     | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=cortex-a73      | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=cortex-a75      | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=cortex-a76      | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=cortex-a77      | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=cortex-a78      | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=cortex-a710     | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=neoverse-n1     | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=neoverse-v1     | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=neoverse-n2     | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=neoverse-v2     | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=apple-a16 -mattr=-fuse-literals | FileCheck %s
; RUN: llc %s -o - -mtriple=aarch64-unknown -mcpu=apple-a17 -mattr=-fuse-literals | FileCheck %s

@g = common local_unnamed_addr global ptr null, align 8

define dso_local ptr @addldr(i32 %a, i32 %b) {
; CHECK-LABEL: addldr:
; CHECK: adrp [[R:x[0-9]+]], addldr
; CHECK-NEXT: add {{x[0-9]+}}, [[R]], :lo12:addldr
entry:
  %add = add nsw i32 %b, %a
  %idx.ext = sext i32 %add to i64
  %add.ptr = getelementptr i8, ptr @addldr, i64 %idx.ext
  store ptr %add.ptr, ptr @g, align 8
  ret ptr %add.ptr
}


define double @litf() {
; CHECK-LABEL: litf:
; CHECK:      adrp [[ADDR:x[0-9]+]], [[CSTLABEL:.LCP.*]]
; CHECK-NEXT: ldr  {{d[0-9]+}}, {{[[]}}[[ADDR]], :lo12:[[CSTLABEL]]{{[]]}}
entry:
  ret double 0x400921FB54442D18
}
