defmodule ExampleSharedSpec do
  use ESpec, shared: true

# This shared spec will always be included!
#  describe "makes sure" do
#    it "this spec is shared by other files" do
#       expect("hello world!") |> to(eq "hello world!")
#    end
#  end
end
