defmodule Tree do
  defstruct key: nil, val: nil, left: nil, right: nil

  def tree(key, val, left, right) do
    %Tree{key: key, val: val, left: left, right: right}
  end
end

defmodule DepthFirst do
  @scale 30

  defstruct tree: nil, rootX: nil, rightLim: nil

  def returnScale do
    @scale
  end

  def tripla(tree, root_x, right_lim) do
    %DepthFirst{tree: tree, rootX: root_x, rightLim: right_lim}
  end

  def addXYv2(tree, x, y) do
    Map.merge(tree, %{x: x, y: y})
  end

  def depthFirst(fatherKey, tree, level, leftLim) do
    case tree do
      %Tree{left: nil, right: nil} ->
        x = leftLim
        y = @scale * level
        IO.inspect({%{Key: tree.key, Val: tree.val}, x, y})
        if fatherKey == tree.key do
          addXYv2(tree, x, y)
        else
          tripla(addXYv2(tree, x, y), x, x)
        end

      %Tree{left: %Tree{}, right: nil} ->
        tripla1 = depthFirst(fatherKey, tree.left, level + 1, leftLim)
        x = tripla1.rootX
        y = @scale * level
        left = tripla1.tree
        IO.inspect({%{Key: tree.key, Val: tree.val}, x, y})
        if fatherKey == tree.key do
          Map.merge(addXYv2(tree, x, y), %{left: left})
        else
          tripla(Map.merge(addXYv2(tree, x, y), %{left: left}), tripla1.rootX, tripla1.rightLim)
        end

      %Tree{left: nil, right: %Tree{}} ->
        tripla1 = depthFirst(fatherKey, tree.right, level + 1, leftLim)
        x = tripla1.rootX
        y = @scale * level
        right = tripla1.tree
        IO.inspect({%{Key: tree.key, Val: tree.val}, x, y})
        if fatherKey == tree.key do
          Map.merge(addXYv2(tree, x, y), %{right: right})
        else
          tripla(Map.merge(addXYv2(tree, x, y), %{right: right}), tripla1.rootX, tripla1.rightLim)
        end

      %Tree{left: %Tree{}, right: %Tree{}} ->
        tripla1 = depthFirst(fatherKey, tree.left, level + 1, leftLim)
        rLeftLim = tripla1.rightLim + @scale
        tripla2 = depthFirst(fatherKey, tree.right, level + 1, rLeftLim)
        leftX = tripla1.rootX
        rightX = tripla2.rootX
        x = if tree.left != nil && tree.right != nil do
          (leftX + rightX) / 2
        else
          (leftX + rightX + @scale) / 2
        end
        y = @scale * level
        left = tripla1.tree
        right = tripla2.tree
        IO.inspect({%{Key: tree.key, Val: tree.val}, x, y})
        if fatherKey == tree.key do
          Map.merge(addXYv2(tree, x, y), %{left: left, right: right})
        else
          tripla(Map.merge(addXYv2(tree, x, y), %{left: left, right: right}), x, tripla2.rightLim)
        end
    end
  end
end

# Criando uma árvore para ser usada na chamada
tree =
  Tree.tree(:a, 111,
    Tree.tree(:b, 55,
      Tree.tree(:x, 100,
        Tree.tree(:z, 56, nil, nil),
        Tree.tree(:w, 23, nil, nil)
      ),
      Tree.tree(:y, 105, nil,
        Tree.tree(:r, 77, nil, nil)
      )
    ),
    Tree.tree(:c, 123,
      Tree.tree(:d, 119,
        Tree.tree(:g, 44, nil, nil),
        Tree.tree(:h, 50,
          Tree.tree(:i, 5, nil, nil),
          Tree.tree(:j, 6, nil, nil)
        )
      ),
      Tree.tree(:e, 133, nil, nil)
    )
  )

DepthFirst.depthFirst(tree.key, tree, 1, DepthFirst.returnScale())
