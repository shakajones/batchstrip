defmodule ExampleSharedSpec do
  use ESpec, shared: true

  # This shared spec will always be included!
  example "" do
    it "" do
    end
  end
end
