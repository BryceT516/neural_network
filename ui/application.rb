module NeuralNetwork
  class Application < Gtk::Application
    def initialize
      super 'com.neural_network.gtk-run', Gio::ApplicationFlags::FLAGS_NONE

      signal_connect :activate do |application|
        window = NeuralNetwork::ApplicationWindow.new(application)
        window.present
      end
    end
  end
end