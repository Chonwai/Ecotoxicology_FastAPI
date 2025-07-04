# 生態毒理學預測API文檔

## 概述

生態毒理學預測API是一個微服務，專門用於預測化合物對魚類、甲殼類和藻類的毒性。該服務基於圖卷積神經網絡(GCN)模型，能夠從SMILES分子結構預測潛在的生態毒性。

## 服務資訊

- **基礎URL**: `http://[服務器地址]:8890`
- **版本**: 1.0.0

## 模型類型

系統支援三種不同的毒性預測模型：

| 模型代碼 | 描述 |
|---------|------|
| F2F | 魚類毒性預測模型 (Fish) |
| C2C | 甲殼類毒性預測模型 (Crustacean) |
| A2A | 藻類毒性預測模型 (Algae) |

## API端點

### 預測毒性

**端點**: `POST /api/predict`

對一個或多個化合物進行生態毒性預測。

#### 請求格式

```json
{
  "fasta": ">[序列ID]\n[SMILES序列]\n>[序列ID2]\n[SMILES序列2]",
  "model_type": "F2F"
}
```

**參數說明**:

- `fasta` (字符串, 必填): FASTA格式的化合物序列，可包含多個序列
  - 每個序列以`>`開頭的行表示序列ID
  - 隨後的行包含SMILES格式的化合物結構
- `model_type` (字符串, 必填): 選擇使用的模型類型，可選值有：
  - `F2F`: 魚類毒性預測模型
  - `C2C`: 甲殼類毒性預測模型
  - `A2A`: 藻類毒性預測模型

#### 響應格式

```json
{
  "status": "success",
  "data": {
    "fasta_ids": ["序列ID1", "序列ID2"],
    "smiles": ["SMILES序列1", "SMILES序列2"],
    "predictions": [0.123, 0.456]
  }
}
```

**響應參數**:

- `status`: 表示請求處理狀態
- `data`: 包含預測結果的數據
  - `fasta_ids`: 輸入序列的ID列表
  - `smiles`: SMILES格式的化合物序列列表
  - `predictions`: 每個化合物的毒性預測值列表，數值介於0到1之間

#### 錯誤響應

在發生錯誤時，API將返回HTTP錯誤狀態碼和錯誤描述：

- **400 Bad Request**: 當請求參數不正確或SMILES序列無效時
  ```json
  {
    "detail": "不支持的模型類型"
  }
  ```
  或
  ```json
  {
    "detail": "處理SMILES時出錯: [具體錯誤信息]"
  }
  ```

- **500 Internal Server Error**: 當服務器內部發生錯誤時
  ```json
  {
    "detail": "模型未正確載入"
  }
  ```

## 使用示例

### 請求示例

```bash
curl -X POST "http://[服務器地址]:8890/api/predict" \
     -H "Content-Type: application/json" \
     -d '{
       "fasta": ">Compound1\nCCCC\n>Compound2\nCNC=O",
       "model_type": "F2F"
     }'
```

### 響應示例

```json
{
  "status": "success",
  "data": {
    "fasta_ids": ["Compound1", "Compound2"],
    "smiles": ["CCCC", "CNC=O"],
    "predictions": [0.123, 0.456]
  }
}
```

## 注意事項

1. SMILES序列應遵循標準SMILES格式規範
2. 較長或複雜的SMILES序列可能需要更長的處理時間
3. 預測結果僅供參考，不應作為唯一決策依據
4. 建議測試時從少量化合物開始，確保格式正確 