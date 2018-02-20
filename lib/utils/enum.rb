module Utils
  class Enum < Hash
    def self.create(hash)
      e = self.new
      e.merge(hash)
    end

    # ENUM一覧(配列)
    def enums
      target_columns(:enum)
    end

    # 名前一覧
    def names
      target_columns(:name)
    end

    # ENUMの指定カラムから定義ハッシュを求める
    def get_entry_by(column, value)
      self.values.find { |hash| value == hash[column] }
    end

    # ENUMの名前から定義ハッシュを求める
    def get_entry_by_name(name)
      get_entry_by(:name, name)
    end

    # ENUM数値から定義ハッシュを求める
    def get_entry_by_enum(enum)
      get_entry_by(:enum, enum)
    end

    # 登録キーから定義ハッシュを求める
    def get_entry_by_key(key)
      return unless self.key?(key)
      self[key]
    end

    # ENUMの名前から定義ハッシュを求める
    def get_column_by_name(name, column)
      res = get_entry_by_name(name)
      res.try(:fetch, column.to_sym, nil)
    end

    # ENUM数値から定義ハッシュを求める
    def get_column_by_enum(enum, column)
      res = get_entry_by_enum(enum)
      res.try(:fetch, column.to_sym, nil)
    end

    # 登録キーから指定カラムを求める
    def get_column_by_key(key, column)
      return unless self.key?(key)
      self[key].try(:fetch, column.to_sym, nil)
    end

    # ENUMの名前からENUM数値を求める
    def get_enum_by_name(name)
      get_column_by_name(name, :enum)
    end

    # ENUMの登録キーからENUM数値を求める
    def get_enum_by_key(key)
      get_column_by_key(key, :enum)
    end

    # ENUM数値からENUMの名前を求める
    def get_name_by_enum(enum)
      get_column_by_enum(enum, :name)
    end

    # 登録キーからENUMの名前を求める
    def get_name_by_key(key)
      get_column_by_key(key, :name)
    end

    # ENUMの指定カラムから登録キーを取得
    def get_key_by_column(column, value)
      self.find { |_, v| v[column] == value }.try(:first)
    end

    # ENUMの値から登録キーを取得
    def get_key_by_enum(enum)
      get_key_by_column(:enum, enum)
    end

    # ENUMの名前から登録キーを取得
    def get_key_by_name(name)
      get_key_by_column(:name, name)
    end

    def get_key(arg)
      case arg
      when Symbol
        self.key?(arg) ? arg : nil
      when Integer
        self.get_key_by_enum(arg)
      end
    end

    # 登録キーに対応するENMU一覧
    def enums_for(target_keys)
      case target_keys
      when ::Array
      when ::String
        target_keys = [target_keys.to_sym]
      when ::Symbol
        target_keys = [target_keys]
      end
      self.each_with_object([]) { |(key, val), arry| arry << val[:enum] if target_keys.include?(key) }
    end

    # 指定したカラム名の一覧取得
    def target_columns(column)
      self.values.each_with_object([]) do |hash, arry|
        next unless hash.key?(column)
        arry << hash[column]
      end
    end

    # 引数に渡したキーのみを対象にする
    def select_keys(keys)
      self.each_with_object({}) { |(k, v), hash| hash.store(k, v) if keys.include?(k) }
    end

    # 指定した数値カラムで並べ替えを行ったキー一覧配列
    # NOTE: 現状マスター取り込みの優先度での並び替え想定
    # 戻り値: 並び替え後のキー配列 (指定したcolumnが存在しない場合はnil)
    # 引数:   order シンボル(:desc 降順 :asc 昇順)
    def sorted_keys(column, order = :asc)
      key_columns = sort_by_columns(column, order)
      return if key_columns.blank?
      key_columns.each_with_object([]) do |(key, _val), arry|
        arry << key
      end
    end

    # 指定したカラム名とキーのHashペア一覧取得
    def get_key_column_pair(column)
      res_hash = {}
      self.each_pair do |key, entry|
        return nil unless entry.key?(column)
        res_hash.store(key, entry[column])
      end
      res_hash
    end

    private

    ############################################################
    # 内部メソッド
    # NOTE: 直接呼ばれることは考慮していない
    ############################################################
    # 指定した数値カラム値でソート
    # 戻り値: [[key,column値],[key,column値]]
    # 引数:   order シンボル(:desc 降順 :asc 昇順)
    def sort_by_columns(column, order = :asc)
      sort_array = get_key_column_pair(column)
      if sort_array.present?
        case order
        when :asc
          sort_array = sort_array.sort { |(_k1, v1), (_k2, v2)| v1 <=> v2 }
        when :desc
          sort_array = sort_array.sort { |(_k1, v1), (_k2, v2)| v2 <=> v1 }
        end
      end
      sort_array
    end
  end
end
