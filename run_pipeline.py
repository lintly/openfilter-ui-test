#!/usr/bin/env python3
import os
import logging
from openfilter.filter_runtime.filter import Filter
from openfilter.filter_runtime.filters.video_in import VideoIn
from openfilter.filter_runtime.filters.webvis import Webvis

# Configure console logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s [%(levelname)s] %(name)s: %(message)s"
)
logger = logging.getLogger(__name__)


def main():
    # Resolve the path to the sample video file in our workspace
    current_dir = os.path.dirname(os.path.abspath(__file__))
    video_path = os.path.join(current_dir, "data", "combined_video.mp4")

    if not os.path.exists(video_path):
        logger.error(f"Video file not found at: {video_path}")
        return

    logger.info(f"Using video source: {video_path}")

    # Define the pipeline configuration
    pipeline_definition = [
        # 1. Video Input Filter
        (
            VideoIn,
            {
                "id": "video_source",
                "sources": f"file://{video_path}!loop",
                "outputs": "tcp://*:5550",
            },
        ),
        # 2. Web Visualization Sink Filter
        (
            Webvis,
            {
                "id": "webvis_sink",
                "sources": "tcp://localhost:5550",
                "port": 8000,
            },
        ),
    ]

    logger.info("Starting OpenFilters Pipeline (VideoIn -> Webvis)...")
    logger.info("Point your browser to http://localhost:8000 once running.")

    try:
        # Launch the multi-filter pipeline
        Filter.run_multi(pipeline_definition)
    except KeyboardInterrupt:
        logger.info("Pipeline stopped by user.")


if __name__ == "__main__":
    main()
