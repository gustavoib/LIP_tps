defmodule Parser do
  defmodule NodeBegin do
    defstruct begin: nil, left: nil, right: nil

    def new(begin, left, right) do
      %NodeBegin{begin: begin, left: left, right: right}
    end
  end

  defmodule NodeState do
    defstruct state: nil, left: nil, right: nil

    def new(state, operator, left, right) do
      %NodeState{state: state, left: left, right: right}
    end
  end

  defmodule NodeUnario do
    defstruct state: nil, id: nil

    def new(state, id) do
      %NodeUnario{state: state, id: id}
    end
  end

  defmodule NodeBinario do
    defstruct operator: nil, left: nil, right: nil

    def new(operator, left, right) do
      %NodeBinario{operator: operator, left: left, right: right}
    end
  end

  def prog(s1) do
    [head1 | s2] = s1
    if head1 == :program do
      aux = id(s2)
      if elem(aux, 0) or not isIdent(elem(aux, 1)) do
        y = elem(aux, 1)
        s3 = elem(aux, 2)
        [head2 | s4] = s3
        if head2 == ';' do
          {z, s5} = stat(s4)
          [head3 | sn] = s5
          if head3 == 'end' do
            {NodeBegin.new(:program, y, z), sn}
          end
        end
      end
    end
  end

  def stat(s1) do
    [t | s2] = s1
    case t do
      :if ->
        {c, s3} = comp(s2)
        [head4 | s4] = s3
        if head4 == :then do
          {x1, s5} = stat(s4)
          #[head5 | s6] = s5
          head5 = hd(s5)
          s6 = tl(s5)
          if head5 == :else do
            {x2, s7} = stat(s6) 
            {NodeState.new(:if, c, x1, x2), s7}
          else
            {NodeBinario.new(:if, c, x1), s5}  
          end
        end

      :while ->
        {c, s3} = comp(s2)
        #[head6 | s4] = s3
        head6 = hd(s3)
        s4 = tl(s3)
        if head6 == :do do
          {x, s5} = stat(s4)
          {NodeBinario.new(:while, c, x), s5}  
        end

      :read ->
        {aux, i, s3} = id(s2)
        if aux do
          {NodeUnario.new(:read, i), s3}
        end

      :write ->
        {e, s3} = expr(s2)
        {NodeUnario.new(:read, e), s3}

      _ ->
        if isIdent(t) do
          [head7 | s3] = s2
          if head7 == ':=' do
            {e, s4} = expr(s3)
            {NodeBinario.new(:assing, t, e), s4}
          end
        end
    end
  end

  def sequence(nonTerm, sep, s1) do
    {x1, s2} = nonTerm.(s1)
    [t | s3] = s2
    if sep.(t) do
      {x2, sn} = sequence(nonTerm, sep, s3)
      {NodeBinario.new(t, x1, x2), sn}
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

  def fact(s1) do
    [t | s2] = s1
    if is_integer(t) or isIdent(t) do
      {t, s2}
    else
      [a | s2] = s1
      if a == '(' do
        {e, s3} = expr(s2)
        [a | sn] = s3
        if a == ')' do
          {e, sn}
        end
      end
    end
  end

  def id(s1) do
    case s1 do
      nil -> false
      _ ->
        [x | sn] = s1
        if isIdent(x) do
          {true, x, sn}
        else
          {false, x, sn}
        end
    end
  end

  def isIdent(id) do
    Enum.member?([';', :if, :while, :read, :write, ':='], id) or is_atom(id)
  end

  #FORMATAÇÃO DA SAÍDA
  def format_tree(node) when is_atom(node) do
      to_string(node)
    end

  def format_tree(node) when is_integer(node) do
    Integer.to_string(node)
  end

  def format_tree(node) do
    case node do
      %NodeBegin{begin: begin, left: left, right: right} ->
        "#{begin} (#{left} #{format_tree(right)})"
      %NodeState{state: state, left: left, right: right} ->
        "#{state} (#{left} #{format_tree(right)})"
      %NodeUnario{state: state, id: id} ->
        "(#{state} #{id})"
      %NodeBinario{operator: operator, left: left, right: right} ->
        "#{operator} (#{format_tree(left)} #{format_tree(right)})"
    end
  end
end

#CHAMADA DO PROGRAMA
programa = [:program, 'foo', ';', :while, :a, '+', 3, '<', :b, :do, :b, ':=', :b, '+', 1, 'end']
{syntatic,sn} = Parser.prog(programa)
#é possível ver a arvore gerada a partir da implementação em elixir, usando esse comando: IO.inspect(syntatic)
syntatic_tree = Parser.format_tree(syntatic)
IO.puts(syntatic_tree)
