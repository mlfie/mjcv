require 'test/unit'
require 'test_helper'
require 'mlfielib/analysis/mentsu_resolver'
require 'mlfielib/analysis/pai'
require 'mlfielib/analysis/mentsu'
require 'mlfielib/analysis/tehai'

class MentsuResolverTest < Test::Unit::TestCase
  
  def setup
    super
    @resolver = Mlfielib::Analysis::MentsuResolver.new
  end
  
  def teardown
    @resolver = nil
    super
  end
  
#*****************************************************************#
# step1. pai_itemsをPaiオブジェクトの配列で取得する
#*****************************************************************#
  # get_pai_list正常系
  def test_normal_get_pai_list
    pai_items = "m1tm2tm3tp1tp1bp1bp2tp2ts7ls8bs9tp4rp5bp6t"
    @resolver.get_mentsu(pai_items)
    
    @resolver.tehai_list.each do |tehai|
      tehai.mentsu_list.each do |mentsu|
        mentsu.pai_list.each do |pai|
          case pai.number
            when 4
              assert_equal  true,   pai.naki
            when 5..6
              assert_equal  false,  pai.naki
            when 7
              assert_equal  true,   pai.naki
            when 8..9
              assert_equal  false,  pai.naki
            else
          end
        end
      end
    end

    assert_equal Mlfielib::Analysis::MentsuResolver::RESULT_SUCCESS, @resolver.result_code
  end

  # get_pai_list異常系
  def test_error_get_pai_list
    pai_items = "a1tm2tm3tp1tp1bp1bp2tp2ts7ls8bs9tp4rp5bp6t"
    @resolver.get_mentsu(pai_items)
    
    assert_equal Mlfielib::Analysis::MentsuResolver::RESULT_ERROR_INTERFACE, @resolver.result_code
  end
  
#*****************************************************************#
# step2. 副露面子を取得する
#*****************************************************************#
  # get_furo正常系1
  # step1-1-1, step1-1-7-4-2
  def test_normal_get_furo_1
    pai_items = "m1tm2tm3tr0tp1tp1br0tp2tp2tp8tp8tp8tp8lp9tp9tp9r"
    @resolver.get_mentsu(pai_items)
    
    @resolver.tehai_list.each do |tehai|
      tehai.mentsu_list.each do |mentsu|
        # step1-1-1
        if mentsu.pai_list[0].number == 9 then 
          assert_equal  9,      mentsu.pai_list[0].number
          assert_equal  false,  mentsu.pai_list[0].naki
          assert_equal  9,      mentsu.pai_list[1].number
          assert_equal  false,  mentsu.pai_list[1].naki
          assert_equal  9,      mentsu.pai_list[2].number
          assert_equal  true,   mentsu.pai_list[2].naki
          assert_equal  Mlfielib::Analysis::Mentsu::MENTSU_TYPE_KOUTSU, mentsu.mentsu_type
          assert_equal  true,   mentsu.furo
        # step1-1-7-4-2
        elsif mentsu.pai_list[0].number == 8 then
          assert_equal  8,      mentsu.pai_list[0].number
          assert_equal  false,  mentsu.pai_list[0].naki
          assert_equal  8,      mentsu.pai_list[1].number
          assert_equal  false,  mentsu.pai_list[1].naki
          assert_equal  8,      mentsu.pai_list[2].number
          assert_equal  false,  mentsu.pai_list[2].naki
          assert_equal  8,      mentsu.pai_list[3].number
          assert_equal  true,   mentsu.pai_list[3].naki
          assert_equal  Mlfielib::Analysis::Mentsu::MENTSU_TYPE_KANTSU,   mentsu.mentsu_type
          assert_equal  true,   mentsu.furo
        end
      end
    end

    assert_not_equal Mlfielib::Analysis::MentsuResolver::RESULT_ERROR_NAKI, @resolver.result_code
  end

  # get_furo正常系2
  # step1-1-2, step1-1-7-1, step1-2
  def test_normal_get_furo_2
    pai_items = "m1tm2tm3tp2tp2tp6lp7tp8tp8tp8lp8tp9tp9tp9r"
    @resolver.get_mentsu(pai_items)
    
    @resolver.tehai_list.each do |tehai|
      tehai.mentsu_list.each do |mentsu|
        # step1-1-2
        if mentsu.pai_list[0].number == 9 then
          assert_equal  9,      mentsu.pai_list[0].number
          assert_equal  false,  mentsu.pai_list[0].naki
          assert_equal  9,      mentsu.pai_list[1].number
          assert_equal  false,  mentsu.pai_list[1].naki
          assert_equal  9,      mentsu.pai_list[2].number
          assert_equal  true,   mentsu.pai_list[2].naki
          assert_equal  Mlfielib::Analysis::Mentsu::MENTSU_TYPE_KOUTSU,   mentsu.mentsu_type
          assert_equal  true,   mentsu.furo
        # step1-1-7-1
        elsif mentsu.pai_list[0].number == 8 then
          assert_equal  8,      mentsu.pai_list[0].number
          assert_equal  false,  mentsu.pai_list[0].naki
          assert_equal  8,      mentsu.pai_list[1].number
          assert_equal  true,   mentsu.pai_list[1].naki
          assert_equal  8,      mentsu.pai_list[2].number
          assert_equal  false,  mentsu.pai_list[2].naki
          assert_equal  Mlfielib::Analysis::Mentsu::MENTSU_TYPE_KOUTSU,   mentsu.mentsu_type
          assert_equal  true,   mentsu.furo
        # step1-2
        elsif mentsu.pai_list[0].number == 6 then
          assert_equal  6,      mentsu.pai_list[0].number
          assert_equal  true,   mentsu.pai_list[0].naki
          assert_equal  7,      mentsu.pai_list[1].number
          assert_equal  false,  mentsu.pai_list[1].naki
          assert_equal  8,      mentsu.pai_list[2].number
          assert_equal  false,  mentsu.pai_list[2].naki
          assert_equal  Mlfielib::Analysis::Mentsu::MENTSU_TYPE_SHUNTSU,  mentsu.mentsu_type
          assert_equal  true,   mentsu.furo
        end
      end
    end

    assert_not_equal Mlfielib::Analysis::MentsuResolver::RESULT_ERROR_NAKI, @resolver.result_code
  end

  # get_furo正常系3
  # step1-1-4, step1-1-7-3, step2-1(, step1-2)
  def test_normal_get_furo_3
    pai_items = "m1tm1tp9tp9rp9tp9tp7lp7tp7tp7tp8tp8tp8tp8rm1lm2tm3t"
    @resolver.get_mentsu(pai_items)
    
    @resolver.tehai_list.each do |tehai|
      tehai.mentsu_list.each do |mentsu|
        # step1-1-4
        if mentsu.pai_list[0].number == 9 then
          assert_equal  9,      mentsu.pai_list[0].number
          assert_equal  false,  mentsu.pai_list[0].naki
          assert_equal  9,      mentsu.pai_list[1].number
          assert_equal  true,   mentsu.pai_list[1].naki
          assert_equal  9,      mentsu.pai_list[2].number
          assert_equal  false,  mentsu.pai_list[2].naki
          assert_equal  9,      mentsu.pai_list[3].number
          assert_equal  false,  mentsu.pai_list[3].naki
          assert_equal  Mlfielib::Analysis::Mentsu::MENTSU_TYPE_KANTSU,   mentsu.mentsu_type
          assert_equal  true,   mentsu.furo
        # step1-1-7-3
        elsif mentsu.pai_list[0].number == 8 then
          assert_equal  8,      mentsu.pai_list[0].number
          assert_equal  false,  mentsu.pai_list[0].naki
          assert_equal  8,      mentsu.pai_list[1].number
          assert_equal  false,  mentsu.pai_list[1].naki
          assert_equal  8,      mentsu.pai_list[2].number
          assert_equal  false,  mentsu.pai_list[2].naki
          assert_equal  8,      mentsu.pai_list[3].number
          assert_equal  true,   mentsu.pai_list[3].naki
          assert_equal  Mlfielib::Analysis::Mentsu::MENTSU_TYPE_KANTSU,   mentsu.mentsu_type
          assert_equal  true,   mentsu.furo
        # step2-1
        elsif mentsu.pai_list[0].number == 7 then
          assert_equal  7,      mentsu.pai_list[0].number
          assert_equal  true,   mentsu.pai_list[0].naki
          assert_equal  7,      mentsu.pai_list[1].number
          assert_equal  false,  mentsu.pai_list[1].naki
          assert_equal  7,      mentsu.pai_list[2].number
          assert_equal  false,  mentsu.pai_list[2].naki
          assert_equal  7,      mentsu.pai_list[3].number
          assert_equal  false,  mentsu.pai_list[3].naki
          assert_equal  Mlfielib::Analysis::Mentsu::MENTSU_TYPE_KANTSU,   mentsu.mentsu_type
          assert_equal  true,   mentsu.furo
        # step1-2
        elsif mentsu.pai_list[0].number == 1 then
          assert_equal  1,      mentsu.pai_list[0].number
          assert_equal  true,   mentsu.pai_list[0].naki
          assert_equal  2,      mentsu.pai_list[1].number
          assert_equal  false,  mentsu.pai_list[1].naki
          assert_equal  3,      mentsu.pai_list[2].number
          assert_equal  false,  mentsu.pai_list[2].naki
          assert_equal  Mlfielib::Analysis::Mentsu::MENTSU_TYPE_SHUNTSU,  mentsu.mentsu_type
          assert_equal  true,   mentsu.furo
        end
      end
    end

    assert_not_equal Mlfielib::Analysis::MentsuResolver::RESULT_ERROR_NAKI, @resolver.result_code
  end
  
  # get_furo正常系4
  # step1-1-6(, step1-2)
  def test_normal_get_furo_4
    pai_items = "m1tm1ts7ts8ts9ts9rs9ts9tm1lm2tm3tm4lm5tm6t"
    @resolver.get_mentsu(pai_items)
    
    @resolver.tehai_list.each do |tehai|
      tehai.mentsu_list.each do |mentsu|
        # step1-1-6
        if mentsu.pai_list[0].number == 9 then
          assert_equal  9,      mentsu.pai_list[0].number
          assert_equal  true,   mentsu.pai_list[0].naki
          assert_equal  9,      mentsu.pai_list[1].number
          assert_equal  false,  mentsu.pai_list[1].naki
          assert_equal  9,      mentsu.pai_list[2].number
          assert_equal  false,  mentsu.pai_list[2].naki
          assert_equal  Mlfielib::Analysis::Mentsu::MENTSU_TYPE_KOUTSU,   mentsu.mentsu_type
          assert_equal  true,   mentsu.furo
        # step1-2
        elsif mentsu.pai_list[0].number == 1 then
          assert_equal  1,      mentsu.pai_list[0].number
          assert_equal  true,   mentsu.pai_list[0].naki
          assert_equal  2,      mentsu.pai_list[1].number
          assert_equal  false,  mentsu.pai_list[1].naki
          assert_equal  3,      mentsu.pai_list[2].number
          assert_equal  false,  mentsu.pai_list[2].naki
          assert_equal  Mlfielib::Analysis::Mentsu::MENTSU_TYPE_SHUNTSU,  mentsu.mentsu_type
          assert_equal  true,   mentsu.furo
        # step1-2
        elsif mentsu.pai_list[0].number == 4 then
          assert_equal  4,      mentsu.pai_list[0].number
          assert_equal  true,   mentsu.pai_list[0].naki
          assert_equal  5,      mentsu.pai_list[1].number
          assert_equal  false,  mentsu.pai_list[1].naki
          assert_equal  6,      mentsu.pai_list[2].number
          assert_equal  false,  mentsu.pai_list[2].naki
          assert_equal  Mlfielib::Analysis::Mentsu::MENTSU_TYPE_SHUNTSU,  mentsu.mentsu_type
          assert_equal  true,   mentsu.furo
        end
      end
    end

    assert_not_equal Mlfielib::Analysis::MentsuResolver::RESULT_ERROR_NAKI, @resolver.result_code
  end

  # get_furo正常系5
  # step1-1-7-4-3(, step1-2)
  def test_normal_get_furo_5
    pai_items = "m1tm1tr0ts1ts1tr0ts7ts8ts9ts9rs9ts9tm4lm5tm6t"
    @resolver.get_mentsu(pai_items)
    
    @resolver.tehai_list.each do |tehai|
      tehai.mentsu_list.each do |mentsu|
        # step1-1-7-4-3
        if mentsu.pai_list[0].number == 9 then
          assert_equal  9,      mentsu.pai_list[0].number
          assert_equal  true,   mentsu.pai_list[0].naki
          assert_equal  9,      mentsu.pai_list[1].number
          assert_equal  false,  mentsu.pai_list[1].naki
          assert_equal  9,      mentsu.pai_list[2].number
          assert_equal  false,  mentsu.pai_list[2].naki
          assert_equal  Mlfielib::Analysis::Mentsu::MENTSU_TYPE_KOUTSU,   mentsu.mentsu_type
          assert_equal  true,   mentsu.furo
        # step1-2
        elsif mentsu.pai_list[0].number == 4 then
          assert_equal  4,      mentsu.pai_list[0].number
          assert_equal  true,   mentsu.pai_list[0].naki
          assert_equal  5,      mentsu.pai_list[1].number
          assert_equal  false,  mentsu.pai_list[1].naki
          assert_equal  6,      mentsu.pai_list[2].number
          assert_equal  false,  mentsu.pai_list[2].naki
          assert_equal  Mlfielib::Analysis::Mentsu::MENTSU_TYPE_SHUNTSU,  mentsu.mentsu_type
          assert_equal  true,   mentsu.furo
        end
      end
    end

    assert_not_equal Mlfielib::Analysis::MentsuResolver::RESULT_ERROR_NAKI, @resolver.result_code
  end
  
  # get_furo異常系1
  # step1-1-5
  def test_error_get_furo_1
    pai_items = "m1tm1ts8ts9ts9rs9ts9tm1lm2tm3tp8lp8tp8tp8t"
    @resolver.get_mentsu(pai_items)
    
    assert_equal Mlfielib::Analysis::MentsuResolver::RESULT_ERROR_NAKI, @resolver.result_code
  end

  # get_furo異常系2
  # step1-1-7-4-4
  def test_error_get_furo_2
    pai_items = "m1tm1tr0ts1tr0ts7ts8ts9ts9rs9ts9tm1lm2tm3t"
    @resolver.get_mentsu(pai_items)
    
    assert_equal Mlfielib::Analysis::MentsuResolver::RESULT_ERROR_NAKI, @resolver.result_code
  end

  # get_furo異常系3
  # step1-3
  def test_error_get_furo_3
    pai_items = "m1tm1ts7ts7ts7ts8ts8ts8ts9ts9ts9tp4tp5rp6t"
    @resolver.get_mentsu(pai_items)
    
    assert_equal Mlfielib::Analysis::MentsuResolver::RESULT_ERROR_NAKI, @resolver.result_code
  end

  # get_furo異常系4
  # step2-2
  def test_error_get_furo_4
    pai_items = "m1tm1ts7ts7ts7ts8ts8ts8ts9ts9ts9rp4tp5tp6t"
    @resolver.get_mentsu(pai_items)
    
    assert_equal Mlfielib::Analysis::MentsuResolver::RESULT_ERROR_NAKI, @resolver.result_code
  end

#*****************************************************************#
# step3. 暗槓を取得する
#*****************************************************************#
  # get_ankan正常系
  def test_normal_get_ankan
    pai_items = "m1tm1tr0ts7ts7tr0ts8tr0tr0ts8tp4tp5tp6tr0ts9ts9tr0t"
    @resolver.get_mentsu(pai_items)
    
    ankan_list = @resolver.tehai_list[0].mentsu_list.select { |mentsu| 
      mentsu.mentsu_type == Mlfielib::Analysis::Mentsu::MENTSU_TYPE_KANTSU && !mentsu.furo
    }
    
    assert_equal  3,  ankan_list.size

    ankan_list.each do |ankan|
      case ankan.pai_list[0].number
        when 7 then
          assert_equal  7,      ankan.pai_list[0].number
          assert_equal  false,  ankan.pai_list[0].naki
          assert_equal  7,      ankan.pai_list[1].number
          assert_equal  false,  ankan.pai_list[1].naki
          assert_equal  7,      ankan.pai_list[2].number
          assert_equal  false,  ankan.pai_list[2].naki
          assert_equal  7,      ankan.pai_list[3].number
          assert_equal  false,  ankan.pai_list[3].naki
        when 8 then
          assert_equal  8,      ankan.pai_list[0].number
          assert_equal  false,  ankan.pai_list[0].naki
          assert_equal  8,      ankan.pai_list[1].number
          assert_equal  false,  ankan.pai_list[1].naki
          assert_equal  8,      ankan.pai_list[2].number
          assert_equal  false,  ankan.pai_list[2].naki
          assert_equal  8,      ankan.pai_list[3].number
          assert_equal  false,  ankan.pai_list[3].naki
        when 9 then
          assert_equal  9,      ankan.pai_list[0].number
          assert_equal  false,  ankan.pai_list[0].naki
          assert_equal  9,      ankan.pai_list[1].number
          assert_equal  false,  ankan.pai_list[1].naki
          assert_equal  9,      ankan.pai_list[2].number
          assert_equal  false,  ankan.pai_list[2].naki
          assert_equal  9,      ankan.pai_list[3].number
          assert_equal  false,  ankan.pai_list[3].naki
      end
    end
    
    assert_not_equal Mlfielib::Analysis::MentsuResolver::RESULT_ERROR_INTERFACE, @resolver.result_code
  end

  # get_ankan異常系
  def test_error_get_ankan
    pai_items = "m1tm1ts7tr0ts7tr0ts8tr0tr0ts8tp4tp5tp6tr0ts9ts9tr0t"
    @resolver.get_mentsu(pai_items)
        
    assert_equal Mlfielib::Analysis::MentsuResolver::RESULT_ERROR_INTERFACE, @resolver.result_code
  end

#*****************************************************************#
# step4. アガリ牌を設定する
#*****************************************************************#
  # set_agari正常系
  def test_set_agari
    pai_items = "m1tm1tm2tm2tm2tm3tm3tm3tm4tm5tm6tm7lm8tm9t"
    @resolver.get_mentsu(pai_items)
    
    agari_list = Array.new
    @resolver.tehai_list.each do |tehai|
      tehai.mentsu_list.each do |mentsu|
        mentsu.pai_list.each do |pai|
          if pai.agari then
            agari_list << pai
            assert_equal 6, pai.number
          end
        end
      end
    end
    
    assert_not_equal nil, @resolver.tehai_list
    assert_not_equal 0, @resolver.tehai_list.size
    assert_equal @resolver.tehai_list.size, agari_list.size
  end

#*****************************************************************#
# step5. 雀頭候補を取得する
#*****************************************************************#

#*****************************************************************#
# step6-1. 雀頭を除く門前手牌を牌の種類毎に集計する
#*****************************************************************#

#*****************************************************************#
# step6-2. 手牌候補として門前手牌を面子の組み合わせ分だけ作成する
#*****************************************************************#

#*****************************************************************#
# step7. 雀頭候補が7枚の場合、七対子の可能性がある
#*****************************************************************#
  # set_tehai_7toitsu正常系
  def test_set_tehai_7toitsu
    pai_items = "m1tm1ts4ts5ts6ts4ts5ts6tp7tp9tp7tp8tp8tp9t"
    @resolver.get_mentsu(pai_items)
    
    assert_equal 2, @resolver.tehai_list.size
    tehai = @resolver.tehai_list.select { |tehai| tehai.mentsu_list.size == 6 }
    assert_not_equal nil, tehai[0]
    tehai[0].mentsu_list.each do |mentsu|
      assert_equal Mlfielib::Analysis::Mentsu::MENTSU_TYPE_TOITSU, mentsu.mentsu_type
      assert_equal false, mentsu.furo
    end
  end

#*****************************************************************#
# step8. 雀頭が存在して面子が完全に揃わない場合、国士無双 or　十三不塔の可能性がある
#*****************************************************************#
  # set_tehai_tokusyu正常系
  def test_set_tehai_tokusyu
    pai_items = "m1tm9ts1ts9tp1tp9tj1tj2tj3tj4tj5tj6tj7tj7t"
    @resolver.get_mentsu(pai_items)
    
    assert_not_equal nil, @resolver.tehai_list
    assert_equal 1, @resolver.tehai_list.size
    assert_equal 1, @resolver.tehai_list[0].mentsu_list.size
    assert_equal 7, @resolver.tehai_list[0].atama.number
    assert_equal Mlfielib::Analysis::Mentsu::MENTSU_TYPE_TOKUSYU, @resolver.tehai_list[0].mentsu_list[0].mentsu_type
  end

end