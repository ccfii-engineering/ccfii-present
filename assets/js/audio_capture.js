import { Socket } from "phoenix";

export class AudioCapture {
  constructor(eventUuid, audioToken) {
    this.eventUuid = eventUuid;
    this.audioToken = audioToken;
    this.socket = null;
    this.channel = null;
    this.mediaRecorder = null;
    this.stream = null;
  }

  async start() {
    try {
      this.stream = await navigator.mediaDevices.getUserMedia({ audio: true });

      this.socket = new Socket("/audio", {
        params: { token: this.audioToken },
      });
      this.socket.connect();

      this.channel = this.socket.channel(`audio:${this.eventUuid}`, {});
      this.channel
        .join()
        .receive("ok", () => {
          console.log("Joined audio channel");
          this.startRecording();
        })
        .receive("error", (resp) => {
          console.error("Unable to join audio channel", resp);
        });
    } catch (err) {
      console.error("Failed to start audio capture:", err);
    }
  }

  startRecording() {
    const mimeType = MediaRecorder.isTypeSupported("audio/webm;codecs=opus")
      ? "audio/webm;codecs=opus"
      : "audio/webm";

    this.mediaRecorder = new MediaRecorder(this.stream, { mimeType });

    this.mediaRecorder.ondataavailable = (event) => {
      if (event.data.size > 0 && this.channel) {
        const reader = new FileReader();
        reader.onloadend = () => {
          const base64 = reader.result.split(",")[1];
          this.channel.push("audio_chunk", { data: base64 });
        };
        reader.readAsDataURL(event.data);
      }
    };

    // Record in 5-second chunks
    this.mediaRecorder.start(5000);
  }

  stop() {
    if (this.mediaRecorder && this.mediaRecorder.state !== "inactive") {
      this.mediaRecorder.stop();
    }
    if (this.stream) {
      this.stream.getTracks().forEach((track) => track.stop());
      this.stream = null;
    }
    if (this.channel) {
      this.channel.leave();
      this.channel = null;
    }
    if (this.socket) {
      this.socket.disconnect();
      this.socket = null;
    }
  }
}
