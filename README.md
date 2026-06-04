# cc-switch

Claude Code provider/key 切换工具。一条命令在多个 API Key / Provider 之间切换。

## 功能

- `cc <provider>` — 指定 provider 启动 Claude Code
- `cc` — 交互式选择 provider
- `cc --list` — 列出所有可用 provider
- 支持自定义模型名（适配第三方 provider）

## 安装

### 方式一：作为 Claude Code Plugin 安装（推荐）

在 Claude Code 中执行：

```
/plugin marketplace add Huaer02/cc-switch
/plugin install cc-switch@cc-switch
```

然后执行 `/cc-switch` 按指引完成配置。

### 方式二：一键脚本

```bash
curl -fsSL https://raw.githubusercontent.com/Huaer02/cc-switch/main/install.sh | zsh
```

### 方式三：手动安装

```bash
git clone https://github.com/Huaer02/cc-switch.git
cd cc-switch
cp cc.sh ~/.claude/cc.sh
cp providers.example.json ~/.claude/providers.json
echo '\n# Claude Code provider switcher\nsource ~/.claude/cc.sh' >> ~/.zshrc
source ~/.zshrc
```

---

## ⚠️ 安装后必须配置 providers.json

**安装脚本只会帮你把文件放到位。你还需要手动编辑 `~/.claude/providers.json` 填入你自己的 API Key 和 Provider 信息，否则 `cc` 无法正常工作。**

打开配置文件：

```bash
vim ~/.claude/providers.json
# 或
code ~/.claude/providers.json
```

把里面的示例内容替换成你真实的 provider 信息。

---

## 配置格式

### 基本结构

```json
{
  "providers": {
    "provider名称": {
      "description": "简短描述",
      "base_url": "API 地址",
      "auth_token": "你的 API Key"
    }
  },
  "default": "provider名称"
}
```

### 多 Key 示例

适用于同一 provider 下有多个 API Key 的场景：

```json
{
  "providers": {
    "key1": {
      "description": "主力 key",
      "base_url": "https://api.anthropic.com",
      "auth_token": "sk-ant-your-key-1"
    },
    "key2": {
      "description": "备用 key",
      "base_url": "https://api.anthropic.com",
      "auth_token": "sk-ant-your-key-2"
    }
  },
  "default": "key1"
}
```

### 自定义模型名（非 Anthropic 原生 provider）

如果你的 provider 使用自定义模型名称，可以通过 model 字段覆盖：

```json
{
  "providers": {
    "custom": {
      "description": "自定义 provider",
      "base_url": "https://your-provider-api.com",
      "auth_token": "your-token",
      "model": "custom-model-name",
      "sonnet_model": "custom-sonnet",
      "opus_model": "custom-opus",
      "haiku_model": "custom-haiku"
    }
  }
}
```

### 常见大模型 API 地址参考

| Provider | base_url |
|----------|----------|
| Anthropic 官方 | `https://api.anthropic.com` |
| DeepSeek | `https://api.deepseek.com` |
| 智谱 GLM | `https://open.bigmodel.cn/api/paas/v4` |
| Mimo | `https://api.mimo.ai` |
| OpenAI | `https://api.openai.com` |
| Moonshot (Kimi) | `https://api.moonshot.cn/v1` |
| 通义千问 | `https://dashscope.aliyuncs.com/compatible-mode/v1` |

### 字段说明

| 字段 | 必填 | 说明 |
|------|------|------|
| `description` | 否 | 在 `cc --list` 和交互选择时显示 |
| `base_url` | 是 | API 地址 |
| `auth_token` | 是 | API Key / Token |
| `model` | 否 | 覆盖默认模型名 |
| `sonnet_model` | 否 | 覆盖 Sonnet 模型名 |
| `opus_model` | 否 | 覆盖 Opus 模型名 |
| `haiku_model` | 否 | 覆盖 Haiku 模型名 |

---

## 日常使用

```bash
cc key1          # 用 key1 启动
cc custom        # 用自定义 provider 启动
cc               # 交互式选择
cc --list        # 查看所有 provider
```

添加/修改/删除 provider 只需编辑 `~/.claude/providers.json`，改完立刻生效。

## 依赖

- zsh
- jq
- Claude Code (`claude` 命令可用)
