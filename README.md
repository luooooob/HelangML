<h1 align="center">
  <img width="300" src="logo.svg" alt="Logo">
  <img alt="GitHub Workflow Status" src="https://img.shields.io/github/workflow/status/luooooob/helangml/Main%20workflow?style=for-the-badge">
  <img alt="GitHub top language" src="https://img.shields.io/github/languages/top/luooooob/helangml?label=OCaml&style=for-the-badge">
</h1>

## 介绍

OCaml 实在是太酷了，很符合我对未来编程语言的想象，正确、高效又优雅

我们正需要这样棒的语言来实现`何语言`([helang](https://github.com/kifuan/helang))

## 语法

大概长这样
```
u8 x = 1 | 1 | 4 | 5 | 1 | 4;
x[2] = 7;
x;

x[ 2 | 3 | 4 ] = 7;
print x ;

u8 y = 1 | 2 | 3 | 4 | 5 ;
u8 z = y + 8;
print y;

print 1 + 5 * 2;
```

更多骚话还没编出来，先看看原作者写的吧 

[基本语法](https://github.com/kifuan/helang#%E5%9F%BA%E6%9C%AC%E8%AF%AD%E6%B3%95)

## Playground

可以在 Playground 目录试用

```sh
dune exec bin/main.exe ./playground/hello.he
```

## 开发 

```sh
dune build
dune test
```

## todo

- [ ] 更多语法
- [ ] read-eval-print loop (REPL)
