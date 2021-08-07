require "set"
require "byebug"
class WordChainer
    attr_reader :dictionary, :all_seen_words
    def initialize(dictionary_file_name)
        @file = File.open(dictionary_file_name)
        @dictionary = (@file.readlines.map(&:chomp)).to_set
        @all_seen_words = Hash.new()
        @current_words = []
    end

    def adjacent_words(word)
        return [] if word == nil
        alpha = ("a".."z").to_a
        arr = []
        i = 0
        while i < word.length
            j = 0
            while j < alpha.length
                str = word.dup
                str[i] = alpha[j]
                if dictionary.include?(str) && (str != word || arr.include?(str))
                    arr << str
                end
                j += 1 
            end
            i += 1
        end
        return arr 
    end

    def run(source, target)
        @current_words << source
        @all_seen_words[source] = nil
        arr = []
        arr += explore_current_words
        return build_path(target)
    end

    def explore_current_words
        arr = []
        while !@current_words.empty?
            new_current_words = []
            i = 0
            while i < @current_words.length
                j = 0 
                while j < adjacent_words(@current_words[i]).length
                    if @all_seen_words.keys.include?(adjacent_words(@current_words[i])[j]) == false
                        new_current_words << adjacent_words(@current_words[i])[j]
                        @all_seen_words[adjacent_words(@current_words[i])[j]] = @current_words[i]
                    end
                    j += 1
                end
                i += 1
            end
            arr += new_current_words
            @current_words = new_current_words
        end
        return arr
    end

    def build_path(target)
        path = [target]
        while @all_seen_words[path[-1]] != nil 
            path << @all_seen_words[path[-1]]
        end
        return path
    end

end