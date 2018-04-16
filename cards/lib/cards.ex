defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """

  @doc """
    Returns a list of strings representing a deck of playing cards
  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    # Multiple comprehension. Similar to a nested for loop,
    # but it will return a flattened array.
    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    Determines whether a deck contains a given card

  ## Examples

      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "Ace of Spades")
      true



  """

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end



  @doc """
    Divides a deck into a hand and the remainder of the deck.
    The `hand_size` argument indicates how many cards should be in the hand

  ## Examples

      iex> deck = Cards.create_deck
      iex> {hand, deck} = Cards.deal(deck, 1)
      iex> hand
      ["Ace of Spades"]

  """
  # returns a tuple
  # Enum.split(deck, hand_size) -> { [My Hand] , [The Rest] }
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  # Write to a file
  def save(deck, filename) do
    # This is how we invoke erlang code
    # :erlang - erlang object with a log of methods we can use
    # Purpose of this method is to take the deck object and turn it into
    # object that can be saved/written to the file system.
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    # case statement looking for a matching tuple
    # The left side of the tuple is hardcoded, the right side is a
    # variable assignment.
    # Looks for the matching case statement of File.read
    #
    # Preferable method because in one statement do comparison AND assignment
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      # the _reason... we know there is something that will appear here,
      # but we don't want to use it/don't need it.
      {:error, _reason} -> "That file doesn't exist"
    end
    # :ok and :error are atoms. :erlang is an object that gives access to methods.
    # atoms are used to handle status codes, messages, control flow
    # Think of them as strings. Difference? Strings are to display to the user
    # Atoms are information to codify as response codes that we see as developers
    # case status do
    #   :ok -> :erlang.binary_to_term(binary)
    #   :error -> "That file does not exist"
    # end

  end

  def create_hand(hand_size) do
    # deck = Cards.create_deck
    # deck = Cards.shuffle(deck)
    # hand = Cards.deal(deck, hand_size)


    Cards.create_deck
    |> Cards.shuffle
    |> Cards.deal(hand_size)
  end
end
