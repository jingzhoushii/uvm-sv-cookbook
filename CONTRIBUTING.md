# Contributing to UVM-SV Cookbook

感谢您考虑为 UVM-SV Cookbook 贡献代码！

## 📝 贡献方式

### 1. 报告问题
- 在 GitHub Issues 中报告 bug
- 描述复现步骤
- 提供相关日志

### 2. 提出改进建议
- 在 GitHub Discussions 中讨论
- 说明改进理由
- 提供参考实现

### 3. 提交代码
1. Fork 本仓库
2. 创建分支 `git checkout -b feature/xxx`
3. 添加代码
4. 提交 `git commit -m "feat: xxx"`
5. 推送 `git push`
6. 发起 Pull Request

## 📋 代码规范

### SystemVerilog 风格

```systemverilog
// 文件头
// ============================================================================
// @file    : filename.sv
// @brief   : Brief description
// @note    : Key points
// ============================================================================

// 缩进：2 空格
// 行宽：120 字符
// 类名：大驼峰 (MyClass)
// 变量名：小写下划线 (my_variable)
// 参数名：大写下划线 (PARAM_NAME)
```

### 提交规范

```
feat:     新功能
fix:      Bug 修复
docs:     文档更新
refactor: 重构
test:     测试相关
chore:    构建/工具
```

## 📂 目录结构

```
chapter/
├── README.md              # 必需：章节文档
├── Makefile              # 必需：编译脚本
├── filelist.f            # 可选：文件列表
├── examples/            # 必需：代码示例
│   └── *.sv
├── tb/                  # 可选：测试平台
│   └── *.sv
└── dut/                 # 可选：被测设计
    └── *.sv
```

## ✅ Pull Request 要求

- [ ] 代码编译通过
- [ ] 有完整的 README
- [ ] 有详细的注释
- [ ] 遵循代码风格
- [ ] 提交信息规范

## 📚 参考资源

- [UVM User Guide](https://www.accellera.org/)
- [ChipVerify](https://www.chipverify.com/)
- [Verification Academy](https://verificationacademy.com/)

---

感谢您的贡献！ 🎉
