defmodule Parser do
  defmodule NoBegin do
    defstruct begin: nil, left: nil, right: nil

    def new(begin, left, right) do
      %NoBegin{begin: begin, left: left, right: right}
    end
  end

  defmodule NoState do
    defstruct state: nil, left: nil, right: nil

    def new(state, operator, left, right) do
      %NoState{state: state, left: left, right: right}
    end
  end

  defmodule NoUnario do
    defstruct state: nil, id: nil

    def new(state, id) do
      %NoUnario{state: state, id: id}
    end
  end

  defmodule NoBinario do
    defstruct operator: nil, left: nil, right: nil

    def new(operator, left, right) do
      %NoBinario{operator: operator, left: left, right: right}
    end
  end

  def prog([head1 | s2]) do
    if head1 == :program do
      aux = id(s2)
      if elem(aux, 0) or not isIdent(elem(aux, 1)) do
        y = elem(aux, 1)
        s3 = elem(aux, 2)
        head2 = hd(s3)
        s4 = tl(s3)
        if head2 == ';' do
          {z, s5} = stat(s4)
          head3 = hd(s5)
          sn = tl(s5)
          if head3 == 'end' do
            {NoBegin.new(:program, y, z), sn}
          end
        end
      end
    end
  end

  def stat([t | s2]) do
    case t do
      :if ->
        {c, s3} = comp(s2)
        head4 = hd(s3)
        s4 = tl(s3)
        if head4 == :then do
          {x1, s5} = stat(s4)
          head5 = hd(s5)
          s6 = tl(s5)
          if head5 == :else do
            {x2, s7} = stat(s6)
            {NoState.new(:if, c, x1, x2), s7}
          else
            {NoBinario.new(:if, c, x1), s5}
          end
        end

      :while ->
        {c, s3} = comp(s2)
        head6 = hd(s3)
        s4 = tl(s3)
        if head6 == :do do
          {x, s5} = stat(s4)
          {NoBinario.new(:while, c, x), s5}
        end

      :read ->
        {aux, i, s3} = id(s2)
        if aux do
          {NoUnario.new(:read, i), s3}
        end

      :write ->
        {e, s3} = expr(s2)
        {NoUnario.new(:read, e), s3}

      _ ->
        if isIdent(t) do
          head7 = hd(s2)
          s3 = tl(s2)
          if head7 == ':=' do
            {e, s4} = expr(s3)
            {NoBinario.new(:assing, t, e), s4}
          end
        end
    end
  end

  def sequence(nonTerm, sep, s1) do
    {x1, s2} = nonTerm.(s1)
    t = hd(s2)
    s3 = tl(s2)
    if sep.(t) do
      {x2, sn} = sequence(nonTerm, sep, s3)
      {NoBinario.new(t, x1, x2), sn}
    else
      {x1, s2}
    end
  end

  def comp(s1) do
    a = &expr/1
    b = &cop/1
    sequence(a, b, s1)
  end

  def expr(s1) do
    a = &term/1
    b = &eop/1
    sequence(a, b, s1)
  end

  def term(s1) do
    a = &fact/1
    b = &top/1
    sequence(a, b, s1)
  end

  def cop(y) do
    y == '<' or y == '>' or y == '=<' or y == '>' or y == '==' or y == '!='
  end

  def eop(y) do
    y == '+' or y == '-'
  end

  def top(y) do
    y == '*' or y == '/'
  end

  def fact([t | s1]) do
    if is_integer(t) or isIdent(t) do
      {t, s1}
    else
      a = hd(s1)
      s2 = tl(s1)
      if a == '(' do
        {e, s3} = expr(s2)
        a = hd(s3)
        sn = tl(s3)
        if a == ')' do
          {e, sn}
        end
      end
    end
  end

  def id([x | sn]) do
    {isIdent(x), x, sn}
  end

  def isIdent(id) do
    Enum.member?([';', :if, :while, :read, :write, ':='], id) or is_atom(id)
  end

  #FORMATAÇÃO DA SAÍDA
  def format_tree(no) when is_atom(no) do
      to_string(no)
    end

  def format_tree(no) when is_integer(no) do
    Integer.to_string(no)
  end

  def format_tree(no) do
    case no do
      %NoBegin{begin: begin, left: left, right: right} ->
        "#{begin} (#{left} #{format_tree(right)})"
      %NoState{state: state, left: left, right: right} ->
        "#{state} (#{left} #{format_tree(right)})"
      %NoUnario{state: state, id: id} ->
        "(#{state} #{id})"
      %NoBinario{operator: operator, left: left, right: right} ->
        "#{operator} (#{format_tree(left)} #{format_tree(right)})"
    end
  end
end

#CHAMADA DO PROGRAMA
programa = [:program, 'programa1', ';', :while, :a, '+', 3, '<', :b, :do, :b, ':=', :b, '+', 1, 'end']
{syntactic,sn} = Parser.prog(programa)
#é possível ver a arvore gerada a partir da implementação em elixir, usando o comando logo abaixo, basta retirar o comentário
#IO.inspect(syntactic)
syntactic_tree = Parser.format_tree(syntactic)
IO.puts(syntactic_tree)
