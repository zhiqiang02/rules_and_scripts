# Rules

gugugu ing

## surge usage

**[Rule]**

```
RULE-SET,https://raw.githubusercontent.com/../xxxx.list,policy
```

## clash usage

**rule-providers:**

```
  xxxx:
    type: http
    behavior: classical
    format: text
    path: ./ruleset/xxxx.list 
    url: "https://raw.githubusercontent.com/../xxxx.list"
    interval: 86400
```

**rules:**

```
  - RULE-SET,xxxx,policy
```
