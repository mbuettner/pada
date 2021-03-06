# coding: utf-8

class Switch

    def initialize(left, right)
        @left = left
        @right = right

        @state = :left
    end

    def process(insn)
        case insn
        when :swap_third
            child_insn = :swap_second
        when :swap_second
            child_insn = :swap_first
        when :swap_first
            toggle
            child_insn = :nop
        when :swap_three
            toggle
            child_insn = :swap_two
        when :swap_two
            toggle
            child_insn = :swap_first
        when :right_third
            child_insn = :right_second
        when :right_second
            child_insn = :right_first
        when :right_first
            @state = :right
            child_insn = :nop
        when :left_third
            child_insn = :left_second
        when :left_second
            child_insn = :left_first
        when :left_first
            @state = :left
            child_insn = :nop
        else
            child_insn = insn
        end
        
        pass_on child_insn        
    end

    def toggle
        if @state == :left
            @state = :right
        else
            @state = :left
        end
    end

    def pass_on(insn)
        left_insn = right_insn = :nop

        if @state == :left
            left_insn = insn
        else
            right_insn = insn
        end

        left = @left.process(left_insn)
        right = @right.process(right_insn)

        left || right
    end

    def to_s
        char = @state == :left ? '/' : '\\'
        children = [@left, @right].map{|s| s.to_s.split($/)}
        width = children[0][0].size
        max_height = children.map(&:size).max
        children = children.map{|s| s.fill(' '*width, s.length...max_height)}.transpose.map{|parts| parts * ' '} * $/
        ' '*width + char + ' '*width + $/ + children
    end
end