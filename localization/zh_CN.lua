return {
  descriptions = {
    Mod = {
      rainydays = {
        name = "雨天",
        text = {
          "含90张原版风格的小丑牌, 与原版Balatro相得益彰。",
          "每张小丑牌的描述都遵循游戏简洁的风格,",
          "在带来新鲜组合的同时不喧宾夺主,与原有卡池保持平衡。"
        }
      }
    },

    Joker = {
      j_RainyDays_absent_heart = {
        name = "缺心",
        text = {
          "Create a {C:tarot}Tarot{} card",
          "every {C:attention}#1# {C:inactive}[#2#]{} cards with",
          "{V:1}#3#{} suit drawn",
          "during a round",
          "{C:inactive}(Must have room)"
        }
      },
      --[[j_RainyDays_absent_heart = {
        name = "缺心",
        text = {
          "每打出{C:attention}#1#{C:inactive}[#2#]{}张",
          "未计分的{V:1}#3#{}花色牌",
          "生成一张{C:tarot}塔罗牌{}",
          "{C:inactive}(必须有空位)"
        }
      },]]

      j_RainyDays_accountant = {
        name = "会计师",
        text = {
          "回合内每抽一张牌",
          "获得{C:mult}+#1#{}倍率",
          "{C:attention}回合{}结束时重置倍率",
          "{C:inactive}(当前{C:mult}+#2#{C:inactive}倍率)"
        },
        unlock = {
          "在牌组为",
          "{E:1,C:attention}空{}时打败盲注"
        }
      },

      j_RainyDays_atom = {
        name = "原子",
        text = {
          "打出的{C:attention}#1#{}计分时",
          "有{C:green}#2#/#3#{}几率使本次",
          "打出的{C:attention}牌型{}获得",
          "{C:mult}+#4#{}倍率"
        }
      },

      j_RainyDays_avocado = {
        name = "牛油果",
        text = {
          "{C:mult}+#1#{}倍率",
          "打开任一{C:attention}补充包{}时",
          "{C:mult}-#2#{}倍率"
        }
      },

      j_RainyDays_balance = {
        name = "平衡",
        text = {
          "本回合每打出一种{C:attention}",
          "不同的牌型{}，{X:mult,C:white}X#1#{}倍率",
          "{C:inactive}(当前{X:mult,C:white}X#2#{C:inactive}倍率)"
        },
        unlock = {
          "本赛局内打出至少",
          "{E:1,C:attention}#1#{}种",
          "{E:1,C:attention}不同的牌型"
        }
      },

      j_RainyDays_bankaccount = {
        name = "银行账户",
        text = {
          "{C:chips}+#1#{}筹码",
          "获得{C:attention}利息{}时，改为等额",
          "添加到这张小丑牌的{C:attention}售价{}上",
        }
      },

      j_RainyDays_bazaar = {
        name = "集市",
        text = {
          "{C:attention}+#1#{}手牌上限",
          "计分牌不能少于{C:attention}#2#{}张"
        }
      },

      j_RainyDays_beanstalk = {
        name = "魔豆藤",
        text = {
          "{C:attention}连续{}每回合至少",
          "使用{C:attention}#2#张{}消耗牌",
          "这张小丑牌",
          "获得{X:mult,C:white}X#1#{}倍率",
          "失败将会重置倍率",
          "{C:inactive}(当前{X:mult,C:white}X#3#{C:inactive}倍率)",
          "{C:inactive}(#4#{C:attention}#5#{C:inactive}#6#)"
        }
      },

      j_RainyDays_blood_moon = {
        name = "血月",
        text = {
          "{X:mult,C:white}X#1#{} Mult",
          "Each played hand,",
          "destroy {C:attention}#2#{} cards",
          "held in hand"
        }
      },
      --[[j_RainyDays_blood_moon = {
        name = "血月",
        text = {
          "打出单张{C:attention}卡牌{}时",
          "将其销毁",
          "下次打出{C:attention}多张{}牌时",
          "{X:mult,C:white}X#1#{}倍率",
          "{C:inactive}(当前{V:1}#2#{C:inactive})"
        }
      },]]

      j_RainyDays_bonsai = {
        name = "盆景",
        text = {
          "在你的牌组中",
          "每剩余{C:attention}#2#{}张",
          " {V:1}#4#{}花色牌",
          "就获得{C:mult}+#1#{}倍率",
          "{C:inactive}(当前{C:mult}+#3#{C:inactive}倍率)"
        },
        unlock = {
          "牌组中拥有{E:1,C:attention}#1#{}张",
          "或更少的{E:1,C:clubs}梅花{}",
          "花色牌"
        }
      },
      
      j_RainyDays_breakdance = {
        name = "Breakdance",
        text = {
          "{X:mult,C:white}X#1#{} Mult if each played",
          "hand this round contained",
          "only scoring cards with",
          "{C:attention}odd{} rank",
          "{C:inactive}(Currently {V:1}#2#{C:inactive})",
          "{C:inactive}(A, 9, 7, 5, 3)"
        },
        unlock = {
          "Have {E:1,C:attention}#1#{} or more",
          "cards with {E:1,C:attention}odd",
          "rank in the deck"
        }
      },

      j_RainyDays_breakfast_cereal = {
        name = "早餐麦片",
        text = {
          "重新触发接下来{C:attention}#1#{}张",
          "计分的{C:attention}增强{}卡牌",
          "之后再生成一个{C:tarot}吊饰标签{}"
        },
        unlock = {
          "本赛局内获得{E:1,C:attention}#1#{}",
          "个或更多的",
          "{E:1,C:attention}标签"
        }
      },

      j_RainyDays_burdenofgreatness = {
        name = "伟业之重",
        text = {
          "回合结束时",
          "生成一个{C:tarot}吊饰标签{}",
          "并使所有",
          "盲注{C:attention}分数{}提高{C:attention}#1#%"
        },
        unlock = {
          "打败Boss盲注，分数至少为",
          "{E:1,C:attention}要求分数的三倍"
        }
      },

      j_RainyDays_catalogue = {
        name = "目录",
        text = {
          "每张弃掉的牌有",
          "{C:green}#1#/#2#{}几率",
          "{C:attention}随机化{}其点数"
        }
      },
      
      j_RainyDays_catwalk = {
        name = "Catwalk",
        text = {
          "Each played card with",
          "an {C:attention}enhancement unique",
          "to played hand gives",
          "{X:mult,C:white}X#1#{} Mult when scored"
        }
      },

      j_RainyDays_checklist = {
        name = "清单",
        text = {
          "本回合中每张打出的牌",
          "若此前的出牌中",
          "打出过其{C:attention}点数{}",
          "则在计分时给予{X:mult,C:white}X#1#{}倍率"
        }
      },
      
      j_RainyDays_checklist_list = {
        name = "Ranks played",
        text = {
          "{V:1}A {V:2}K {V:3}Q {V:4}J",
          "{V:5}10 {V:6}9 {V:7}8 {V:8}7 {V:9}6",
          "{V:10}5 {V:11}4 {V:12}3 {V:13}2"
        }
      },

      j_RainyDays_cleanslate = {
        name = "全新开始",
        text = {
          "{C:mult}+#1#{}倍率",
          "每次弃牌时",
          "弃掉{C:attention}全部{}手牌"
        }
      },

      j_RainyDays_cloverfield = {
        name = "三叶草田",
        text = {
          "每弃掉{C:attention}#3#{C:inactive}[#4#]{}张",
          "{C:clubs}梅花{}花色牌",
          "这张小丑牌获得{C:mult}+#1#{}倍率",
          "{C:inactive}(当前{C:mult}+#2#{C:inactive}倍率)"
        }
      },
      
      j_RainyDays_collage = {
        name = "Collage",
        text = {
          "{X:mult,C:white}X#1#{} Mult for each",
          "{C:attention}unique enhancement",
          "among cards played",
          "this {C:attention}Ante",
          "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
        }
      },

      j_RainyDays_conga_line = {
        name = "康加队列",
        text = {
          "Retrigger each played",
          "card with {C:attention}even{} rank",
          "{C:inactive}(10, 8, 6, 4, 2)"
        },
        unlock = {
          "Have {E:1,C:attention}#1#{} or more",
          "cards with {E:1,C:attention}even",
          "rank in the deck"
        }
      },
      --[[j_RainyDays_conga_line = {
        name = "康加队列",
        text = {
          "重新触发每张打出的",
          "点数为{C:attention}奇数{}的牌"
        },
        unlock = {
          "牌组中拥有{E:1,C:attention}#1#{}张",
          "或更多的{E:1,C:attention}奇数",
          "点数牌"
        }
      },]]

      j_RainyDays_count_orlok = {
        name = "奥洛克伯爵",
        text = {
          "If {C:attention}first hand{{} of round",
          "is a single {C:attention}face{} card,",
          "destroy it. Then this",
          "Joker gains its Chips",
          "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        }
      },
      --[[j_RainyDays_count_orlok = {
        name = "奥洛克伯爵",
        text = {
          "如果出牌中包含至少",
          "{C:attention}#1#{}张{C:attention}人头牌{}",
          "计分后随机摧毁其中一张",
          "这张小丑牌获得{X:mult,C:white}X#2#{}倍率",
          "{C:inactive}(当前{X:mult,C:white}X#3#{C:inactive}倍率)"
        }
      },]]

      j_RainyDays_dancing_moves = {
        name = "舞步",
        text = {
          "如果打出的牌中",
          "包含{C:attention}万能牌{}",
          "重新触发",
          "每张打出的{C:attention}卡牌{}"
        }
      },

      j_RainyDays_dealer = {
        name = "荷官",
        text = {
          "在回合中售出这张",
          "或其他{C:attention}小丑牌{}",
          "获得{C:blue}+#1#{}次出牌"
        },
        unlock = {
          "打出{E:1,C:attention}#1#{}或",
          "更多次出牌后",
          "打败盲注"
        }
      },

      j_RainyDays_delirium = {
        name = "谵妄",
        text = {
          "如果本回合的某次{C:attention}弃牌{}",
          "包含至少{C:attention}#2#{}张",
          "花色{C:attention}各不相同{}的牌",
          "{C:mult}+#1#{}倍率",
          "{C:inactive}(当前{V:1}#3#{C:inactive})"
        }
      },

      j_RainyDays_desolate = {
        name = "荒芜",
        text = {
          "如果本赛局内",
          "{C:attention}弃掉{}了{C:attention}#2#{}或更多种",
          "{C:attention}牌型{}，{X:mult,C:white}X#1#{}倍率",
          "{C:inactive}(#3#{C:attention}#4#{C:inactive}#5#)"
        }
      },
      
      j_RainyDays_early_birds = {
        name = "Early Birds",
        text = {
          "Each played card",
          "drawn in the {C:attention}first",
          "{C:attention}hand{} of this round",
          "gives {C:mult}+#1#{} Mult when",
          "scored"
        }
      },

      j_RainyDays_equity = {
        name = "净值",
        text = {
          "如果手牌中",
          "不包含{C:attention}#2#{}",
          "{C:mult}+#1#{}倍率"
        }
      },

      j_RainyDays_fabergeegg = {
        name = "法贝热彩蛋",
        text = {
          "每有一张",
          "{C:attention}#2#{}或{C:attention}#3#{}计分",
          "这张小丑牌的",
          "{C:attention}售价{}增加{C:money}$#1#{}"
        }
      },

      j_RainyDays_fan_mail = {
        name = "粉丝来信",
        text = {
          "商店中",
          "补充包槽位{C:attention}+#1#{}"
        }
      },

      j_RainyDays_feather_marvelous = {
        name = "奇妙羽毛",
        text = {
          "每张{C:attention}羽毛小丑牌{}",
          "给予{X:mult,C:white}X#1#{}倍率"
        },
        unlock = {
          "拥有{E:1,C:attention}#1#{}张",
          "或更多{E:1,C:attention}羽毛小丑牌{}"
        }
      },

      j_RainyDays_feather_precious = {
        name = "珍贵羽毛",
        text = {
          "回合结束时",
          "每张{C:attention}羽毛小丑牌{}",
          "获得{C:money}$#1#"
        }
      },

      j_RainyDays_feather_silky = {
        name = "柔滑羽毛",
        text = {
          "每张{C:attention}羽毛小丑牌{}",
          "给予{C:mult}+#1#{}倍率"
        }
      },

      j_RainyDays_feather_vibrant = {
        name = "鲜艳羽毛",
        text = {
          "每张{C:attention}羽毛小丑牌{}",
          "给予{C:chips}+#1#{}筹码"
        }
      },
      
      j_RainyDays_five_and_dime = {
        name = "Five-and-dime",
        text = {
          "Each played {C:attention}#1#{} or {C:attention}#2#",
          "gives {C:mult}+#3#{} Mult when",
          "scored. {C:green}#4# in #5#{} chance",
          "it earns {C:money}$#6#{} instead"
        }
      },

      j_RainyDays_flipflop = {
        name = "触发器",
        text = {
          "交替提供",
          "{C:chips}+#2#{}筹码或",
          "{X:mult,C:white}X#1#{}倍率",
          "{C:inactive}(下次出牌: {X:mult,C:white}X#1#{C:inactive}倍率)"
        }
      },

      j_RainyDays_flipflop_odd = {
        name = "触发器",
        text = {
          "交替提供",
          "{C:chips}+#2#{}筹码或",
          "{X:mult,C:white}X#1#{}倍率",
          "{C:inactive}(下次出牌: {C:chips}+#2#{C:inactive}筹码)"
        }
      },
      
      j_RainyDays_folding_chair = {
        name = "Folding Chair",
        text = {
          "{C:attention}+#1#{} hand size for each",
          "of first {C:attention}#2# Steel Cards",
          "drawn during this round",
          "{C:inactive}(Currently {C:attention}+#3#{C:inactive} hand size)"
        }
      },

      j_RainyDays_golden_idol = {
        name = "黄金偶像",
        text = {
          "回合内每抽到一张",
          "{C:attention}黄金牌{}，这张小丑牌",
          "获得{X:mult,C:white}X#1#{}倍率",
          "{C:inactive}(当前{X:mult,C:white}X#2#{C:inactive}倍率)"
        }
      },

      j_RainyDays_goldfish = {
        name = "金鱼",
        text = {
          "如果打出的牌中",
          "不含{C:attention}#2#{}，获得{C:money}$#1#",
        }
      },

      j_RainyDays_grapes = {
        name = "葡萄",
        text = {
          "Next {C:attention}#1#{} played cards",
          "each give {C:mult}+#2#{} Mult",
          "when scored"
        }
      },
      --[[j_RainyDays_grapes = {
        name = "葡萄",
        text = {
          "接下来{C:attention}#1#{}张打出的牌",
          "在计分时每张给予",
          "{C:mult}+#2#{}到{C:mult}+#3#{}倍率"
        }
      },]]

      j_RainyDays_grey_joker = {
        name = "灰色小丑",
        text = {
          "如果{C:attention}弃牌{}中包含{C:attention}#1#{}",
          "这张小丑牌获得{X:mult,C:white}X#2#{}倍率",
          "{C:inactive}(当前{X:mult,C:white}X#3#{C:inactive}倍率)"
        },
        unlock = {
          "牌组中拥有至少",
          "{E:1,C:attention}#1#{}张",
          "{E:1,C:attention}石头牌{}"
        }
      },
      
      j_RainyDays_hannysvoorwerp = {
        name = "哈尼天体",
        text =  {
          "While owning a {C:planet}Planet{} card,",
          "play its listed {C:attention}poker hand",
          "to destroy it and this",
          "Joker gains {C:mult}+#1#{} Mult",
          "{C:inactive}(Currently {C:mult}+#2# {C:inactive}Mult)"
        }
      },
      --[[j_RainyDays_hannysvoorwerp = {
        name = "哈尼天体",
        text = {
          "每{C:attention}售出{}一张{C:planet}星球牌{}",
          "这张小丑牌获得{C:mult}+#1#{}倍率",
          "{C:inactive}(当前{C:mult}+#2#{C:inactive}倍率)"
        }
      },]]
      
      j_RainyDays_hecate = {
        name = "赫卡忒",
        text = {
          "At end of round, create",
          "a {C:spectral}Spectral{} card if cards",
          "held in hand contain a",
          "{C:attention}#1#",
          "{C:inactive}(Must have room)"
        }
      },
      
      --[[j_RainyDays_hecate = {
        name = "赫卡忒",
        text = {
          "如果本回合只打出{C:attention}#1#{}",
          "生成一张{C:spectral}幻灵牌{}",
          "{C:inactive}(必须有空位)"
        }
      },]]

      j_RainyDays_heirloom = {
        name = "传家宝",
        text = {
          "When a played {C:attention}Bonus{} or",
          "{C:attention}Mult Card{} is scored,",
          "{C:green}#1# in #2#{} chance card to",
          "its right gains its",
          "{C:attention}enhancement"
        }
      },
      --[[j_RainyDays_heirloom = {
        name = "传家宝",
        text = {
          "每张打出的与{C:attention}奖励牌{}",
          "或{C:attention}倍率牌{}相邻的牌",
          "有{C:green}#1#/#2#{}几率获得",
          "相同{C:attention}增强效果{}"
        }
      },]]
      
      j_RainyDays_instructional = {
        name = "Instructional",
        text = {
          "Each {C:attention}Joker{} acquired",
          "after this one",
          "gives {C:chips}+#1#{} Chips"
        },
        unlock = {
          "Reach Ante {E:1,C:attention}#1#{} without",
          "ever selling any {E:1,C:attention}Jokers"
        }
      },
      
      j_RainyDays_joker_reject = {
        name = "弃牌小丑",
        text = {
          "{C:red}+#1#{} discards each round,",
          "each discard costs {C:money}$#2#"
        },
        unlock = {
          "During a run,",
          "have at least {E:1,C:attention}#1#",
          "{E:1,C:attention}discards{} go {E:1,C:attention}unused"
        }
      },
      --[[j_RainyDays_joker_reject = {
        name = "弃牌小丑",
        text = {
          "没有剩余弃牌次数时",
          "仍可{C:attention}弃牌{}，但每次",
          "额外弃牌花费{C:money}$#1#"
        },
        unlock = {
          "本赛局内至少有",
          "{E:1,C:attention}#1#{}次{E:1,C:attention}弃牌{}",
          "{E:1,C:attention}未使用{}"
        }
      },]]
      
      j_RainyDays_jungle_jack = {
        name = "Jungle Jack",
        text = {
          "Each played or discarded",
          "{C:attention}#1#{} instead counts as",
          "the {C:attention}rank{} of the card to",
          "their left"
        }
      },

      j_RainyDays_kudzu = {
        name = "葛藤",
        text = {
          "选择{C:attention}盲注{}时生成",
          "另一张{C:attention}葛藤{}",
          "每有一张其他{C:attention}葛藤{}",
          "这张小丑牌{C:mult}+#1#{}倍率",
          "{C:inactive}(当前{C:mult}+#2#{C:inactive}倍率)",
          "{C:inactive}(必须有空位)"
        },
        unlock = {
          "拥有至少{E:1,C:attention}#1#{}张",
          "相同的{E:1,C:attention}小丑牌{}"
        }
      },

      j_RainyDays_lady_in_waiting = {
        name = "侍女",
        text = {
          "When a {C:attention}#1#{} is drawn",
          "during a round, it gains",
          "a random new {C:attention}enhancement",
          "{C:inactive}(Card won't lose rank)"
        },
        unlock = {
          "Have {E:1,C:attention}#1#{} or",
          "more {E:1,C:attention}#2#s",
          "in the deck"
        }
      },
      --[[j_RainyDays_lady_in_waiting = {
        name = "侍女",
        text = {
          "回合内每抽到一张{C:attention}#1#{}",
          "{C:attention}完整牌组{}中的每张牌",
          "永久获得{C:chips}+#2#{}筹码"
        },
        unlock = {
          "牌组中拥有{E:1,C:attention}#1#{}张",
          "或更多的{E:1,C:attention}#2#{}"
        }
      },]]
      
      j_RainyDays_lady_of_the_lake = {
        name = "湖中夫人",
        text = {
          "If played hand contains",
          "at least {C:attention}#1#{} scoring cards,",
          "a random one gains a ",
          "random new {C:attention}enhancement"
        },
        unlock = {
          "Play a hand with",
          "{E:1,C:attention}#1#{} or more unique",
          "{E:1,C:attention}enhancements"
        }
      },
      --[[j_RainyDays_lady_of_the_lake = {
        name = "湖中夫人",
        text = {
          "每次出牌时一张",
          "随机的{C:attention}未增强{}的",
          "{C:attention}计分{}卡牌获得",
          "随机{C:attention}增强效果{}"
        },
        unlock = {
          "打出包含{E:1,C:attention}#1#{}种",
          "或更多不同{E:1,C:attention}增强",
          "效果的牌"
        }
      },]]

      j_RainyDays_legions = {
        name = "军团",
        text = {
          "每张打出的{C:attention}数字{}牌",
          "在计分时给予相当于",
          "其{C:attention}点数{}一半的倍率"
        }
      },
      
      j_RainyDays_letter_board = {
        name = "Letter Board",
        text = {
          "{C:chips}+#1#{} Chips if played",
          "hand contains no",
          "{C:attention}numbered{} cards"
        }
      },

      j_RainyDays_lightning = {
        name = "闪电",
        text = {
          "每张打出的{C:attention}倍率牌{}",
          "在计分时给予{X:mult,C:white}X#1#{}倍率",
          "而非{C:mult}+#2#{}倍率"
        },
        unlock = {
          "牌组中拥有至少",
          "{E:1,C:attention}#1#{}张",
          "{E:1,C:attention}倍率牌{}"
        }
      },

      j_RainyDays_long_road = {
        name = "漫漫长路",
        text = {
          "如果出牌中包含",
          "{C:attention}#2#{}或{C:attention}#3#{}",
          "获得{C:red}+#1#{}次弃牌"
        }
      },

      j_RainyDays_lotteryticket = {
        name = "彩票",
        text = {
          "每回合第一张打出的",
          "{C:attention}#1#{}、{C:attention}#2#{}、{C:attention}#3#{}、{C:attention}#4#{}和{C:attention}#5#{}",
          "在计分时获得{C:money}$#6#{}",
          "{s:0.8}每个回合点数都会变{}"
        },
        unlock = {
          "本赛局内至少成功触发",
          "{E:1,C:attention}幸运牌{}",
          "{E:1,C:attention}#1#{}次"
        }
      },

      j_RainyDays_lotteryticket_short = {
        name = "彩票",
        text = {
          "每回合第一张打出的",
          "{C:attention}#1#{}、{C:attention}#2#{}、{C:attention}#3#{}、{C:attention}#4#{}和{C:attention}#5#{}",
          "在计分时获得{C:money}$#6#{}",
          "{s:0.8}每个回合点数都会变{}"
        }
      },

      j_RainyDays_membership_card = {
        name = "会员卡",
        text = {
          "商店中每件{C:attention}商品{}",
          "便宜{C:money}$#1#{}{C:inactive}(最低{C:money}$1{C:inactive})"
        },
        unlock = {
          "在{E:1,C:attention}单个{}商店中",
          "花费{E:1,C:money}$#1#{}",
          "或更多"
        }
      },

      j_RainyDays_metropolis = {
        name = "大都会",
        text = {
          "如果出牌中包含{C:attention}#1#{}",
          "接下来的{C:attention}#3#{}次出牌",
          "{X:mult,C:white}X#2#{}倍率",
          "{C:inactive}(#4#{V:1}#5#{C:inactive}#6#{C:attention}#7#{C:inactive}#8#)"
        }
      },

      j_RainyDays_minimalist = {
        name = "极简主义者",
        text = {
          "如果有空的{C:attention}小丑牌{}槽位",
          "{C:chips}+#1#{}筹码"
        },
        unlock = {
          "从未拥有任何{E:1,C:attention}小丑牌{}",
          "的情况下到达",
          "底注{E:1,C:attention}#1#{}"
        }
      },

      j_RainyDays_mirror_lake = {
        name = "镜湖",
        text = {
          "如果打出的牌中",
          "包含{C:attention}玻璃牌{}",
          "生成一张{C:tarot}塔罗牌{}",
          "{C:inactive}(必须有空位)"
        }
      },
      
      j_RainyDays_orange = {
        name = "Orange",
        text = {
          "{C:mult}+#1#{} Mult",
          "{C:mult}-#2#{} Mult if played hand",
          "contains fewer than",
          "{C:attention}#3#{} scoring cards"
        }
      },

      j_RainyDays_overflow = {
        name = "溢出",
        text = {
          "如果{C:attention}弃牌{}中",
          "包含{C:attention}#2#{}或{C:attention}#3#{}",
          "本回合{C:attention}+#1#{}手牌上限"
        }
      },

      j_RainyDays_parrot = {
        name = "鹦鹉",
        text = {
          "When {C:attention}Blind{} is selected,",
          "if not copied this {C:attention}Ante{},",
          "copies ability of {C:attention}Joker",
          "to its right this round",
          "{C:inactive}(Currently {V:1}#1#{C:inactive})"
        }
      },
      --[[j_RainyDays_parrot = {
        name = "鹦鹉",
        text = {
          "复制{C:attention}右侧{}小丑牌的",
          "能力，若其在本{C:attention}底注{}",
          "此前的回合未被复制过"
        }
      },]]

      j_RainyDays_plump_joker = {
        name = "胖小丑",
        text = {
          "本{C:attention}底注{}内每使用一张",
          "{C:attention}消耗牌{}获得{C:mult}+#1#{}倍率",
          "底注结束时重置",
          "{C:inactive}(当前{C:mult}+#2#{C:inactive}倍率)"
        },
        unlock = {
          "本赛局内使用{E:1,C:attention}#1#{}张",
          "或更多的{E:1,C:attention}消耗牌{}"
        }
      },
      
      j_RainyDays_polished_joker = {
        name = "Polished Joker",
        text = {
          "This Joker gains {X:mult,C:white}X#1#{} Mult",
          "whenever an {C:attention}enhanced{} card",
          "is given a new {C:attention}enhancement",
          "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
        },
        unlock = {          
          "During a run, give",
          "a new {E:1,C:attention}enhancement{} to",
          "{E:1,C:attention}#1#{} or more {E:1,C:attention}enhanced",
          "cards"
        }
      },

      j_RainyDays_prairie = {
        name = "草原",
        text = {
          "如果打出的{C:attention}牌型{}",
          "不是{C:attention}#2#{}",
          "这张小丑牌获得{C:mult}+#1#{}倍率",
          "{C:inactive}(当前{C:mult}+#3#{C:inactive}倍率)",
          "{s:0.8}回合结束时设为",
          "{s:0.8}最常用的牌型"
        }
      },
      
      j_RainyDays_prehistory = {
        name = "史前",
        text = {
          "This Joker gains {X:mult,C:white}X#1#{} Mult",
          "whenever a {C:attention}Joker{} acquired",
          "before this one is {C:attention}sold",
          "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
        },
        unlock = {
          "During a run,",
          "obtain {E:1,C:attention}#1#{} or",
          "more unique",
          "{E:1,C:attention}Jokers"   
        }
      },

      --[[j_RainyDays_prehistory = {
        name = "史前",
        text = {
          "本赛局内每拥有过一张",
          "{C:attention}不同的小丑牌",
          "这张小丑牌获得{C:chips}+#1#{}筹码",
          "{C:inactive}(当前{C:chips}+#2#{C:inactive}筹码)"
        },
        unlock = {
          "本赛局内获得{E:1,C:attention}#1#{}张",
          "或更多不同的",
          "{E:1,C:attention}小丑牌{}"
        }
      },]]

      j_RainyDays_primality = {
        name = "质数",
        text = {
          "每张计分的",
          "{C:attention}#4#{}、{C:attention}#3#{}、{C:attention}#2#{}和{C:attention}#1#{}变成",
          "{C:attention}万能牌{}"
        }
      },

      j_RainyDays_purple_card = {
        name = "紫牌",
        text = {
          "跳过任一{C:attention}补充包{}时",
          "生成一张{C:tarot}塔罗牌{}",
          "{C:inactive}(必须有空位)"
        }
      },

      j_RainyDays_recycle = {
        name = "回收利用",
        text = {
          "每张弃掉的",
          "{C:attention}#5#{}、{C:attention}#4#{}、{C:attention}#3#{}或{C:attention}#2#",
          "永久获得{C:mult}+#1#{}倍率",
          "并洗回牌组"
        }
      },

      j_RainyDays_roller_skates = {
        name = "轮滑鞋",
        text = {
          "如果本回合{C:attention}弃掉过{}",
          "{C:attention}#2#{}或{C:attention}#3#{}",
          "{X:mult,C:white}X#1#{}倍率",
          "{C:inactive}(当前{V:1}#4#{C:inactive})"
        },
        unlock = {
          "本赛局内弃掉至少",
          "{E:1,C:attention}#1#{}种",
          "不同的{E:1,C:attention}牌型"
        }
      },

      j_RainyDays_self_assembly = {
        name = "自我组装",
        text = {
          "每当一张{C:attention}卡牌{}获得",
          "新的{C:attention}增强效果{}",
          "这张小丑牌{C:mult}+#1#{}倍率",
          "{C:inactive}(当前{C:mult}+#2#{C:inactive}倍率)"
        }
      },

      j_RainyDays_serial = {
        name = "连续",
        text = {
          "每种{C:attention}花色{}的第一张",
          "打出牌在计分时给予",
          "{C:chips}+#1#{}筹码",
          "{C:inactive}(每张牌只算一种花色)"
        }
      },

      j_RainyDays_sextant = {
        name = "六分仪",
        text = {
          "计分牌中{C:attention}最高{}与{C:attention}最低{}",
          "点数之间每差一个点数",
          "获得{C:mult}+#1#{}倍率",
          "{C:inactive}(例: {C:attention}Q{C:inactive} J 10 {C:attention}9{C:inactive} -> {C:mult}+#2#{C:inactive})"
        }
      },
      
      j_RainyDays_shooting_star = {
        name = "Shooting Star",
        text = {
          "If played hand contains",
          "a {C:attention}#2#{}, played {C:attention}poker",
          "{C:attention}hand{} gains {C:chips}+#1#{} Chips"
        },
        unlock = {
          "During a run,",
          "play {E:1,C:attention}#1#{} or more",
          "{E:1,C:attention}#2#es"
        }
      },
      
      j_RainyDays_skinner_box = {
        name = "斯金纳箱",
        text = {
          "At end of round, set",
          "this Joker's {C:attention}sell value",
          "between {C:money}$#1#{} and {C:money}$#2#{}, then",
          "increase max by {C:money}$#3#"
        },
        unlock = {
          "拥有{E:1,C:attention}售出价格{}总和",
          "至少{E:1,C:money}$#1#{}",
          "的小丑牌"
        }
      },

      --[[j_RainyDays_skinner_box = {
        name = "斯金纳箱",
        text = {
          "回合结束时将",
          "这张小丑牌的基础{C:attention}售价{}",
          "设在{C:money}$#1#{}到{C:money}$#2#{}之间",
          "然后上限提高{C:money}$#3#"
        },
        unlock = {
          "拥有{E:1,C:attention}售出价格{}总和",
          "至少{E:1,C:money}$#1#{}",
          "的小丑牌"
        }
      },]]

      j_RainyDays_slashed_joker = {
        name = "割裂小丑",
        text = {
          "如果打出的牌",
          "少于等于{C:attention}#1#{}张",
          "重新触发",
          "每张打出的牌"
        }
      },

      j_RainyDays_snow_shovel = {
        name = "雪铲",
        text = {
          "每计分{C:attention}#3#{C:inactive}[#4#]{}张",
          "{V:1}#5#{}花色牌",
          "这张小丑牌{C:chips}+#1#{}筹码",
          "{C:inactive}(当前{C:chips}+#2#{C:inactive}筹码)"
        }
      },

      j_RainyDays_spooky_joker = {
        name = "阴森小丑",
        text = {
          "本赛局每打出一种不同的",
          "隐藏{C:attention}牌型{}",
          "{X:mult,C:white}X#1#{}倍率",
          "{C:inactive}(当前{X:mult,C:white}X#2#{C:inactive}倍率)"
        },
        unlock = {
          "本赛局内打出至少",
          "{E:1,C:attention}#1#{}种不同的",
          "隐藏{E:1,C:attention}牌型"
        }
      },

      j_RainyDays_sputnik = {
        name = "人造卫星",
        text = {
          "本{C:attention}底注{}内首次打出",
          "某种{C:attention}牌型{}时",
          "生成对应的{C:planet}星球牌{}",
          "{C:inactive}(必须有空位)"
        }
      },
      
      j_RainyDays_squiggle_joker = {
        name = "Squiggle Joker",
        text = {
          "Earn {C:money}$#1#{} if cards held",
          "in hand have exactly",
          "{C:attention}#2#{} suits among them"
        }
      },

      j_RainyDays_star_chart = {
        name = "星图",
        text = {
          "本赛局内每使用过一张{C:planet}星球牌{}",
          "这张小丑牌获得{C:chips}+#1#{}筹码",
          "{C:inactive}(当前{C:chips}+#2#{C:inactive}筹码)"
        },
        unlock = {
          "本赛局内使用{E:1,C:attention}#1#{}张",
          "或更多的{E:1,C:planet}星球牌{}"
        }
      },
      
      j_RainyDays_starting_line = {
        name = "Starting Line",
        text = {
          "{X:mult,C:white}X#1#{} Mult if played",
          "{C:attention}poker hand{} has been",
          "played {C:attention}#2#{} times or",
          "fewer this run"
        }
      },

      j_RainyDays_theater = {
        name = "剧院",
        text = {
          "计分前抽牌至{C:attention}手牌上限{}",
          "手牌中的每张{C:attention}人头{}牌",
          "给予{C:mult}+#1#{}倍率"
        },
        unlock = {
          "手中持有{E:1,C:attention}#1#{}张",
          "或更多{E:1,C:attention}人头牌{}",
          "时打败盲注"
        }
      },

      j_RainyDays_throne = {
        name = "王座",
        text = {
          "如果牌顶的牌是{C:attention}人头{}牌",
          "{X:mult,C:white}X#1#{}倍率",
          "{C:inactive}(当前{V:1}#2#{C:inactive})"
        }
      },
      
      j_RainyDays_trading_stamps = {
        name = "Trading Stamps",
        text = {
          "Every {C:money}$#1#{} spent adds",
          "{C:money}$#2#{} of {C:attention}sell value{} to",
          "this Joker",
          "{C:inactive}({C:money}$#3# {C:inactive}more)"
        },
        unlock = {
          "During a run,",
          "spend {E:1,C:money}$#1#{} or",
          "more"
        }
      },

      j_RainyDays_train_ticket = {
        name = "火车票",
        text = {
          "如果打出的牌中包含",
          "{C:attention}#2#{}张或更多{C:attention}连续{}点数的牌",
          "这张小丑获得{C:mult}+#1#{}倍率",
          "{C:inactive}(当前{C:mult}+#3#{C:inactive}倍率)"
        },
        unlock = {
          "本赛局内打出{E:1,C:attention}#1#{}次",
          "或更多{E:1,C:attention}#2#{}"
        }
      },

      j_RainyDays_truffle = {
        name = "松露",
        text = {
          "{X:mult,C:white}X#1#{}倍率",
          "回合结束时{C:attention}牌组{}中每",
          "{C:attention}剩余{}一张牌",
          "失去{X:mult,C:white}X#2#{}倍率"
        }
      },

      j_RainyDays_wanted = {
        name = "通缉令！",
        text = {
          "售出{C:attention}#1#",
          "{C:attention}#2#{}以获得{C:money}$#3#",
          "{s:0.8}每个回合小丑都会变",
        }
      },

      j_RainyDays_waveform = {
        name = "波形",
        text = {
          "每张打出的{C:attention}卡牌{}有",
          "{C:green}#1#/#2#{}几率重新触发",
          "并在{C:attention}重新触发{}时",
          "给予{C:mult}+#3#{}倍率"
        }
      },
      
      j_RainyDays_windowsill = {
        name = "窗台",
        text = {
          "Create a {C:spectral}Spectral{} card", 
          "every {C:attention}#1#{} {C:inactive}[#2#]{} cards with",
          "{V:1}#3#{} suit held in",
          "hand at end of round",
          "{C:inactive}(Must have room)"
        }
      },

      --[[j_RainyDays_windowsill = {
        name = "窗台",
        text = {
          "回合内每累计抽到",
          "{C:attention}#1#{}{C:inactive}[#2#]{}张{V:1}#3#{}花色牌",
          "生成张{C:planet}星球牌{}",
          "{C:inactive}(必须有空位)"
        }
      },]]

      j_RainyDays_wishbone = {
        name = "许愿骨",
        text = {
          "{C:chips}+#1#{}筹码",
          "售出此牌以生成",
          "{C:tarot}#2#",
          "{C:tarot}#3#",
          "每个回合{C:tarot}塔罗牌{}都会改变",
          "{C:inactive}(必须有空位)"
        }
      },

      j_RainyDays_wishbone_short = {
        name = "许愿骨",
        text = {
          "{C:chips}+#1#{}筹码",
          "售出此牌以生成{C:tarot}#2#",
          "每个回合{C:tarot}塔罗牌{}都会改变",
          "{C:inactive}(必须有空位)"
        }
      }
    }
  },

  misc = {
    dictionary = {
      --config
      rainydays_clarifiers_info = {
        "Some Jokers have a need for the player to track",
        "certain variables. Either icons drawn on top of",
        "the Jokers or additional infoboxes when hovering",
        "can make for a more fluid player experience"
      },
      rainydays_clarifiers_options = {
        "Show indicators and lists",
        "Show indicators",
        "Show infobox lists",
        "Show neither"
      },
      rainydays_discover_all = "全部发现",
      rainydays_include_feathers = "包含羽毛小丑牌",
      rainydays_include_satellite = "Include Satellite",
      rainydays_metallic_highlight_info = {
        "纯视觉效果：部分小丑牌的贴图",
        "带有金属质感的高光"
      },
      rainydays_requires_restart = "(需要重启)",
      rainydays_show_metallic_highlights = "显示金属质感高光",
      rainydays_unlock_all = "全部解锁",
      
      --enhancements shorthand
      rainydays_bonus = "Bonus",
      rainydays_glass = "Glass",
      rainydays_gold = "Gold",
      rainydays_lucky = "Lucky",
      rainydays_mult = "Mult",
      rainydays_steel = "Steel",
      rainydays_stone = "Stone",
      rainydays_wild = "万能",
      
      --joker-specific
      rainydays_balance_box_name = "Hands played",
      
      rainydays_bazaar_message = "必须打出包含5张计分卡牌的牌",
      
      rainydays_beanstalk_grown = "本回合已成长",
      rainydays_beanstalk_message_postfix = "张消耗牌",
      rainydays_beanstalk_message_prefix = "",
      rainydays_beanstalk_or_will_reset = "，回合结束时重置",
      rainydays_beanstalk_postfix = "张",
      rainydays_beanstalk_prefix = "还差",
      
      rainydays_collage_box_name = "Enhancements played",
      
      rainydays_desolate_box_name = "Hands discarded",
      rainydays_desolate_message_postfix = "种",
      rainydays_desolate_message_prefix = "",
      rainydays_desolate_postfix_active = "",
      rainydays_desolate_postfix_inactive = "种",
      rainydays_desolate_prefix_active = "当前",
      rainydays_desolate_prefix_inactive = "",
      
      rainydays_lotteryticket_full_clear = "全部清除！",
      
      rainydays_instructional_box_name = "Jokers affected",
      
      rainydays_metropolis_infix_active = "接下来",
      rainydays_metropolis_infix_inactive = "",
      rainydays_metropolis_message_postfix = " remaining",
      rainydays_metropolis_message_prefix = "",
      rainydays_metropolis_postfix_active = "次出牌",
      rainydays_metropolis_postfix_active_plural = " 次出牌",
      rainydays_metropolis_postfix_inactive = "",
      rainydays_metropolis_prefix_active = "当前",
      rainydays_metropolis_prefix_inactive = "当前",
      
      rainydays_parrot_box_name = "Copied Jokers",
      rainydays_parrot_copied_before = "已复制过",
      
      rainydays_prehistory_box_name = "Eligible Jokers",
      
      rainydays_sputnik_box_name = "Hands played",
      
      rainydays_starting_line_box_name = "Hands played too often",
      
      rainydays_trading_stamps_message_postfix = " more",
      rainydays_trading_stamps_message_prefix = "$",
      
      --message
      rainydays_activated = "已激活！",
      rainydays_danger = "危险提升了！",
      rainydays_deactivated = "Inactive",
      rainydays_denied = "被驳回！",
      rainydays_destroyed = "Destroyed!",
      rainydays_enhanced = "已增强！",
      rainydays_found_target = "Found target!",
      rainydays_full_reset = "Full reset",
      rainydays_hands_upgraded = "牌型已升级！",
      rainydays_new_rank = "新点数！",
      rainydays_wild_ex = "万能!",
      
      --misc
      rainydays_infobox_nr_sign_postfix = "",
      rainydays_infobox_nr_sign_prefix = " #",
      rainydays_message_countdown_postfix = "...",
      rainydays_message_countdown_prefix = "",
      rainydays_plus = "+",
      
      --status
      rainydays_active = "已激活",
      rainydays_hidden = "隐藏",
      rainydays_inactive = "未激活",
      
      --terms
      rainydays_constellation = "星座",
      rainydays_feather = "Feather",
      rainydays_hand = "次出牌",
      rainydays_hand_size = "手牌上限"
      
      --JokerDisplay
      rainydays_JD_booster_pack = " Booster Pack",
      rainydays_JD_discarded = "Discarded ",
      rainydays_JD_discards = " discards",
      rainydays_JD_drawn = "Drawn ",
      rainydays_JD_hand_size = " hand size",
      rainydays_JD_hold_no_postfix = "",
      rainydays_JD_hold_no_prefix = "Hold no ",
      rainydays_JD_hold_postfix = "",
      rainydays_JD_hold_prefix = "Hold ",
      rainydays_JD_held = "Held ",
      rainydays_JD_in_deck = " in deck",
      rainydays_JD_max = "Max. ",
      rainydays_JD_membership_postfix = "",
      rainydays_JD_membership_prefix = "Items ",
      rainydays_JD_no_numbers = "No numbers",
      rainydays_JD_no_postfix = "",
      rainydays_JD_no_prefix = "No ",
      rainydays_JD_not_copying = "Not copying",
      rainydays_JD_numbers = "Numbers",
      rainydays_JD_per_discard = " per discard",
      rainydays_JD_required_scores = " scores",
      rainydays_JD_scored = "Scored ",
      rainydays_JD_set_to = "Set to ",
      rainydays_JD_slashed_joker_postfix = " cards",
      rainydays_JD_slashed_joker_prefix = "",
      rainydays_JD_squiggle_joker_postfix = " suits",
      rainydays_JD_squiggle_joker_prefix = ""
    }
  }
}