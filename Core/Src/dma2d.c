/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file    dma2d.c
  * @brief   This file provides code for the configuration
  *          of the DMA2D instances.
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "dma2d.h"
#include "lvgl/lvgl.h"

/* USER CODE BEGIN 0 */

/* USER CODE END 0 */

DMA2D_HandleTypeDef hdma2d;

/* DMA2D init function */
void MX_DMA2D_Init(void)
{

  /* USER CODE BEGIN DMA2D_Init 0 */

  /* USER CODE END DMA2D_Init 0 */

  /* USER CODE BEGIN DMA2D_Init 1 */

  /* USER CODE END DMA2D_Init 1 */
  hdma2d.Instance = DMA2D;
  hdma2d.Init.Mode = DMA2D_M2M;
  hdma2d.Init.ColorMode = DMA2D_OUTPUT_RGB565; /* LCD is RGB565 */
  hdma2d.Init.OutputOffset = 0;
  hdma2d.Init.BytesSwap = DMA2D_BYTES_REGULAR;
  hdma2d.Init.LineOffsetMode = DMA2D_LOM_PIXELS;
  hdma2d.LayerCfg[1].InputOffset = 0;
#if LV_COLOR_DEPTH == 32
  hdma2d.LayerCfg[1].InputColorMode = DMA2D_INPUT_ARGB8888;
#elif LV_COLOR_DEPTH == 24
  hdma2d.LayerCfg[1].InputColorMode = DMA2D_INPUT_RGB888;
#elif LV_COLOR_DEPTH == 16
  hdma2d.LayerCfg[1].InputColorMode = DMA2D_INPUT_RGB565;
#elif LV_COLOR_DEPTH == 8
  hdma2d.LayerCfg[1].InputColorMode = DMA2D_INPUT_L8;
#endif
  hdma2d.LayerCfg[1].AlphaMode = DMA2D_NO_MODIF_ALPHA;
  hdma2d.LayerCfg[1].InputAlpha = 0;
  hdma2d.LayerCfg[1].AlphaInverted = DMA2D_REGULAR_ALPHA;
  hdma2d.LayerCfg[1].RedBlueSwap = DMA2D_RB_REGULAR;
  if (HAL_DMA2D_Init(&hdma2d) != HAL_OK)
  {
    Error_Handler();
  }
  if (HAL_DMA2D_ConfigLayer(&hdma2d, 1) != HAL_OK)
  {
    Error_Handler();
  }

#if LV_COLOR_DEPTH == 8
  uint8_t clut[256 * 3]; /* assuming the stack is large enough */
  for(uint32_t i = 0; i < 256; i++) {
    clut[i * 3] = i;
    clut[i * 3 + 1] = i;
    clut[i * 3 + 2] = i;
  }
  DMA2D_CLUTCfgTypeDef clut_cfg = {.pCLUT=(uint32_t *)clut,
                                   .CLUTColorMode=DMA2D_CCM_RGB888,
                                   .Size=0xff};
  if (HAL_DMA2D_CLUTStartLoad(&hdma2d, &clut_cfg, 1) != HAL_OK)
  {
    Error_Handler();
  }
  if (HAL_DMA2D_PollForTransfer(&hdma2d, HAL_MAX_DELAY) != HAL_OK)
  {
    Error_Handler();
  }
#endif
  /* USER CODE BEGIN DMA2D_Init 2 */

  /* USER CODE END DMA2D_Init 2 */

}

void HAL_DMA2D_MspInit(DMA2D_HandleTypeDef* dma2dHandle)
{

  if(dma2dHandle->Instance==DMA2D)
  {
  /* USER CODE BEGIN DMA2D_MspInit 0 */

  /* USER CODE END DMA2D_MspInit 0 */
    /* DMA2D clock enable */
    __HAL_RCC_DMA2D_CLK_ENABLE();
    __HAL_RCC_DMA2D_FORCE_RESET();
    __HAL_RCC_DMA2D_RELEASE_RESET();

    /* Enable DMA2D global Interrupt */
    HAL_NVIC_SetPriority(DMA2D_IRQn, 5, 0);
    HAL_NVIC_EnableIRQ(DMA2D_IRQn);
  /* USER CODE BEGIN DMA2D_MspInit 1 */

  /* USER CODE END DMA2D_MspInit 1 */
  }
}

void HAL_DMA2D_MspDeInit(DMA2D_HandleTypeDef* dma2dHandle)
{

  if(dma2dHandle->Instance==DMA2D)
  {
  /* USER CODE BEGIN DMA2D_MspDeInit 0 */

  /* USER CODE END DMA2D_MspDeInit 0 */
    /* Peripheral clock disable */
    __HAL_RCC_DMA2D_CLK_DISABLE();

    /* DMA2D interrupt Deinit */
    HAL_NVIC_DisableIRQ(DMA2D_IRQn);
  /* USER CODE BEGIN DMA2D_MspDeInit 1 */

  /* USER CODE END DMA2D_MspDeInit 1 */
  }
}

/* USER CODE BEGIN 1 */

/* USER CODE END 1 */
